import 'dart:math';
import 'package:flutter/material.dart';

// NOTE: Was copied from https://github.com/Jason-Gregoire/sankey_flutter
// Reason being - I'm too dumb to write my own implementaion
// But also - I just want to update label style to my own 

/// A link (flow) between two nodes in the Sankey diagram
class SankeyLink {
  dynamic source; // Resolved SankeyNode
  dynamic target; // Resolved SankeyNode
  double value;
  int index = 0;
  double y0 = 0.0; // Vertical start position at source
  double y1 = 0.0; // Vertical end position at target
  double width = 0.0; // Proportional width of the link

  SankeyLink({required this.source, required this.target, required this.value});
}

/// A node in the Sankey diagram.
class SankeyNode {
  final dynamic id;
  String? label;
  int index = 0;
  double value = 0.0;
  double? fixedValue;
  int depth = 0; // Distance from source
  int height = 0; // Distance to sink
  int layer = 0; // Horizontal column index
  double x0 = 0.0; // Left x
  double x1 = 0.0; // Right x
  double y0 = 0.0; // Top y
  double y1 = 0.0; // Bottom y
  List<SankeyLink> sourceLinks = [];
  List<SankeyLink> targetLinks = [];

  SankeyNode({required this.id, this.label});
}

/// A base [CustomPainter] for rendering a non-interactive Sankey diagram
///
/// This painter:
/// - Draws links between nodes using smooth cubic Bézier paths
/// - Renders nodes as colored rectangles
/// - Optionally draws labels for each node
///
/// Extend this class (e.g., [InteractiveSankeyPainter]) for user-interaction features
class SankeyPainter extends CustomPainter {
  /// List of Sankey nodes with layout geometry
  final List<SankeyNode> nodes;

  /// List of Sankey links that define flow between nodes
  final List<SankeyLink> links;

  /// Default color to use for all nodes
  final Color nodeColor;

  /// Default color to use for all links
  final Color linkColor;

  /// Whether to display node labels beside the nodes
  final bool showLabels;

  SankeyPainter({
    required this.nodes,
    required this.links,
    this.nodeColor = Colors.blue,
    this.linkColor = Colors.grey,
    this.showLabels = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // --- Draw links first, behind nodes ---
    for (SankeyLink link in links) {
      final source = link.source as SankeyNode;
      final target = link.target as SankeyNode;

      final path = Path();
      final xMid = (source.x1 + target.x0) / 2;

      path.moveTo(source.x1, link.y0);
      path.cubicTo(xMid, link.y0, xMid, link.y1, target.x0, link.y1);

      final blendedColor = Color.lerp(Colors.transparent, linkColor, 0.5)!;

      final paint = Paint()
        ..color = blendedColor.withOpacity(0.5)
        ..style = PaintingStyle.stroke
        ..strokeWidth = link.width;

      canvas.drawPath(path, paint);
    }

    // --- Draw nodes and optional labels ---
    for (final node in nodes) {
      final rect = Rect.fromLTWH(
        node.x0,
        node.y0,
        node.x1 - node.x0,
        node.y1 - node.y0,
      );

      final paint = Paint()..color = nodeColor;
      canvas.drawRect(rect, paint);

      if (showLabels && node.label != null) {
        final textSpan = TextSpan(
          text: node.label,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: "Eurostile Round",
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        );
        final textPainter = TextPainter(
          text: textSpan,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr,
        )..layout();

        final labelX = node.x1 + 6;
        final labelY = node.y0 + (node.y1 - node.y0 - textPainter.height) / 2;
        final labelOffset = Offset(labelX, labelY);

        if (labelX + textPainter.width <= size.width) {
          textPainter.paint(canvas, labelOffset);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant SankeyPainter oldDelegate) {
    return oldDelegate.nodes != nodes || oldDelegate.links != links;
  }
}

/// A [SankeyPainter] subclass that adds interactivity:
///
/// - Supports custom node colors per label
/// - Highlights connected links when a node is selected
/// - Applies hover/focus feedback with opacity and borders
class InteractiveSankeyPainter extends SankeyPainter {
  /// Map of node labels to specific colors
  final Map<String, Color> nodeColors;

  /// ID of the currently selected node, if any
  final int? selectedNodeId;

  InteractiveSankeyPainter({
    required List<SankeyNode> nodes,
    required List<SankeyLink> links,
    required this.nodeColors,
    this.selectedNodeId,
    bool showLabels = true,
    Color linkColor = Colors.grey,
  }) : super(
          showLabels: showLabels,
          nodes: nodes,
          links: links,
          nodeColor: Colors.blue, // fallback node color
          linkColor: linkColor,
        );

  /// Blends two colors for transition effects (used in link paths)
  Color blendColors(Color a, Color b) => Color.lerp(a, b, 0.5) ?? a;

  @override
  void paint(Canvas canvas, Size size) {
    // --- Draw enhanced links ---
    for (SankeyLink link in links) {
      final source = link.source as SankeyNode;
      final target = link.target as SankeyNode;

      final sourceColor = nodeColors[source.label] ?? Colors.blue;
      final targetColor = nodeColors[target.label] ?? Colors.blue;
      var blended = blendColors(sourceColor, targetColor);

      // Highlight links connected to the selected node
      final isConnected = (selectedNodeId != null) &&
          (source.id == selectedNodeId || target.id == selectedNodeId);
      blended = blended.withOpacity(isConnected ? 0.9 : 0.5);

      final linkPaint = Paint()
        ..color = blended
        ..style = PaintingStyle.stroke
        ..strokeWidth = link.width;

      final path = Path();
      final xMid = (source.x1 + target.x0) / 2;
      path.moveTo(source.x1, link.y0);
      path.cubicTo(xMid, link.y0, xMid, link.y1, target.x0, link.y1);

      canvas.drawPath(path, linkPaint);
    }

    // --- Draw colored nodes and labels with selection borders ---
    for (SankeyNode node in nodes) {
      final color = nodeColors[node.label] ?? Colors.blue;
      final rect =
          Rect.fromLTWH(node.x0, node.y0, node.x1 - node.x0, node.y1 - node.y0);
      final isSelected = selectedNodeId != null && node.id == selectedNodeId;

      canvas.drawRect(rect, Paint()..color = color);

      if (isSelected) {
        final borderPaint = Paint()
          ..color = Colors.yellow
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4;
        canvas.drawRect(rect, borderPaint);
      }

      final isDark = color.computeLuminance() < 0.35;
      final textColor = isDark ? Colors.white : Colors.black;

      if (node.label != null && showLabels) {
        final textSpan = TextSpan(
          text: node.label,
          style: TextStyle(
            fontFamily: "Eurostile Round",
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        );

        final textPainter = TextPainter(
          text: textSpan,
          textDirection: TextDirection.ltr,
          maxLines: 1,
        );
        textPainter.layout(minWidth: 0, maxWidth: size.width);

        const margin = 6.0;
        final labelY = rect.top + (rect.height - textPainter.height) / 2;
        final labelOffsetRight = Offset(rect.right + margin, labelY);
        final labelOffsetLeft =
            Offset(rect.left - margin - textPainter.width, labelY);

        // Automatically choose a side that fits within the canvas
        final labelOffset =
            (rect.right + margin + textPainter.width <= size.width)
                ? labelOffsetRight
                : (rect.left - margin - textPainter.width >= 0)
                    ? labelOffsetLeft
                    : labelOffsetRight;

        textPainter.paint(canvas, labelOffset);
      }
    }
  }
}

/// Generates a configured [Sankey] layout engine
///
/// The [width] and [height] parameters define the drawing area dimensions
/// [nodeWidth] is the width of each node, and [nodePadding] sets the space between nodes
/// The returned [Sankey] object is pre-configured with the specified dimensions and
/// properties for use in computing the layout
///
/// Example:
/// ```dart
/// final sankey = generateSankeyLayout(
///   width: 1000,
///   height: 600,
///   nodeWidth: 20,
///   nodePadding: 15,
/// );
/// ```
Sankey generateSankeyLayout({
  double width = 1000,
  double height = 600,
  double nodeWidth = 20,
  double nodePadding = 15,
}) {
  return Sankey()
    ..nodeWidth = nodeWidth
    ..nodePadding = nodePadding
    ..x0 = 0
    ..y0 = 0
    ..x1 = width
    ..y1 = height;
}

/// A default palette of 15 visually distinct colors for use in node theming
///
/// These colors can be automatically assigned to nodes if no custom color is provided
const List<Color> defaultNodeColors = [
  Colors.blue,
  Colors.green,
  Colors.purple,
  Colors.deepOrange,
  Colors.redAccent,
  Colors.indigoAccent,
  Colors.red,
  Colors.teal,
  Colors.indigo,
  Colors.brown,
  Colors.grey,
  Colors.deepPurple,
  Colors.pink,
  Colors.amber,
  Colors.lightBlue,
];

/// Utility class for managing node theming
///
/// This class provides methods to retrieve a node's color and contrast text color
/// based on its label. If a custom color is not specified in [nodeColors], a color
/// from [defaultNodeColors] is chosen based on a hash of the node's label
class SankeyNodeThemeManager {
  final Map<String, Color> nodeColors;

  SankeyNodeThemeManager(this.nodeColors);

  /// Returns the color associated with the given [label]
  ///
  /// If no custom color is defined for [label], it selects a default color
  /// from [defaultNodeColors] using a hash
  Color getColor(String label) {
    return nodeColors[label] ??
        defaultNodeColors[label.hashCode % defaultNodeColors.length];
  }

  /// Returns an appropriate text color (white or black) for the background color
  /// assigned to the given [label] to ensure legible contrast
  Color getTextColor(String label) {
    final background = getColor(label);
    final isDark = background.computeLuminance() < 0.05;
    return isDark ? Colors.white : Colors.black;
  }
}

/// Generates a default node color map for a list of [SankeyNode] objects
///
/// Each node's [label] is used to assign a color from [defaultNodeColors] in sequence
/// (cycling through the palette). This is useful as a convenience method when no
/// custom node colors are provided
///
/// Returns a [Map] with the node label as key and the assigned [Color] as value
Map<String, Color> generateDefaultNodeColorMap(List<SankeyNode> nodes) {
  final Map<String, Color> colorMap = {};
  for (int i = 0; i < nodes.length; i++) {
    final label = nodes[i].label;
    if (label != null && !colorMap.containsKey(label)) {
      colorMap[label] = defaultNodeColors[i % defaultNodeColors.length];
    }
  }
  return colorMap;
}

/// Determines if a tap hit a node and returns its [id]; returns null if no node is hit
///
/// [nodes] is the list of [SankeyNode] objects and [tapPos] is the [Offset] of
/// the tap event in the canvas coordinate space
int? detectTappedNode(List<SankeyNode> nodes, Offset tapPos) {
  for (var node in nodes) {
    final rect =
        Rect.fromLTWH(node.x0, node.y0, node.x1 - node.x0, node.y1 - node.y0);
    if (rect.contains(tapPos)) return node.id;
  }
  return null;
}

/// Combines nodes and links with layout logic
///
/// The [SankeyDataSet] class holds the list of nodes and links, and provides a
/// [layout] method that applies the given [Sankey] layout generator to compute
/// the positions and dimensions for the nodes and links
class SankeyDataSet {
  final List<SankeyNode> nodes;
  final List<SankeyLink> links;

  SankeyDataSet({required this.nodes, required this.links});

  /// Computes the layout for the nodes and links using the provided [sankey] generator.
  void layout(Sankey sankey) {
    sankey.layout(nodes, links);
  }
}

/// Builds an interactive painter based on the provided nodes, links, and node colors
///
/// The [selectedNodeId] parameter indicates an optional node ID for which
/// special highlighting may be applied.
/// Returns an instance of [InteractiveSankeyPainter].
InteractiveSankeyPainter buildInteractiveSankeyPainter({
  required List<SankeyNode> nodes,
  required List<SankeyLink> links,
  required Map<String, Color> nodeColors,
  int? selectedNodeId,
  final bool showLabels = true,
}) {
  return InteractiveSankeyPainter(
    nodes: nodes,
    links: links,
    nodeColors: nodeColors,
    selectedNodeId: selectedNodeId,
    showLabels: showLabels,
  );
}

/// A widget that wraps an interactive Sankey diagram
///
/// The [SankeyDiagramWidget] integrates gesture detection for tapping nodes and
/// renders the diagram using a [CustomPaint] widget. It takes a [SankeyDataSet] as
/// its data source, a node colors map, and an optional [selectedNodeId] along with a
/// callback [onNodeTap] which is called when a node is tapped
///
/// The [size] parameter specifies the drawing area for the diagram
class SankeyDiagramWidget extends StatelessWidget {
  final SankeyDataSet data;
  final Map<String, Color> nodeColors;
  final int? selectedNodeId;
  final Function(int?)? onNodeTap;
  final Size size;
  final bool showLabels;

  const SankeyDiagramWidget({
    Key? key,
    required this.data,
    required this.nodeColors,
    this.selectedNodeId,
    this.onNodeTap,
    this.size = const Size(1000, 600),
    this.showLabels = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        final tapped = detectTappedNode(data.nodes, details.localPosition);
        if (onNodeTap != null) onNodeTap!(tapped);
      },
      child: CustomPaint(
        size: size,
        painter: buildInteractiveSankeyPainter(
          nodes: data.nodes,
          links: data.links,
          nodeColors: nodeColors,
          selectedNodeId: selectedNodeId,
          showLabels: showLabels,
        ),
      ),
    );
  }
}

/// Signature for an alignment function, used to compute the horizontal
/// placement of a node. It takes a [SankeyNode] and the total number of columns
/// (or maximum depth) [n], returning the column index where the node should be placed
typedef NodeAlign = int Function(SankeyNode node, int n);

/// Positions the node at the left side, using its [depth] as the column index
///
/// This alignment is equivalent to the d3‑sankey "left" alignment
int sankeyLeft(SankeyNode node, int n) => node.depth;

/// Positions the node at the right side of the diagram by subtracting its
/// [height] from the total number of columns
///
/// This alignment is equivalent to the d3‑sankey "right" alignment
int sankeyRight(SankeyNode node, int n) => n - 1 - node.height;

/// Aligns the node using a justifying algorithm
///
/// It returns the node's [depth] if it has outgoing links (i.e. it is a source),
/// otherwise it assigns the node to the rightmost column. This mirrors d3‑sankey's
/// "justify" alignment
int sankeyJustify(SankeyNode node, int n) =>
    node.sourceLinks.isNotEmpty ? node.depth : n - 1;

/// Centers the node based on its incoming/outgoing relationships
///
/// - If the node has incoming links (i.e. it is a target), its column is set to
///   its [depth].
/// - Otherwise, if it has outgoing links, its column is set to one less than the
///   minimum depth of its target nodes
/// - If neither is available, the node is placed in column 0
///
/// This function mimics d3‑sankey's "center" alignment
int sankeyCenter(SankeyNode node, int n) {
  if (node.targetLinks.isNotEmpty) return node.depth;
  if (node.sourceLinks.isNotEmpty)
    return (node.sourceLinks
            .map((link) => (link.target as SankeyNode).depth)
            .reduce(min)) -
        1;
  return 0;
}

/// A Sankey layout generator that computes the positions and dimensions
/// for the nodes and links in a Sankey diagram
///
/// The layout algorithm follows several steps:
/// 1. Initialize node links
/// 2. Compute node values based on incoming and outgoing flows
/// 3. Assign horizontal positions (depths/layers)
/// 4. Compute node heights (reverse assignment via incoming links)
/// 5. Position nodes vertically
/// 6. Compute the widths of the links
/// 7. Return a [SankeyGraph] containing the positioned nodes and links
///
/// The bounds of the layout are defined by `[x0, y0]` and `[x1, y1]`,
/// while `nodeWidth` and `nodePadding` determine the size and spacing of nodes
class Sankey {
  // Extent bounds.
  double x0, y0, x1, y1;

  // Node width and padding
  double nodeWidth;
  double nodePadding;

  // Alignment function (default is justifying)
  NodeAlign align;

  // Number of relaxation iterations
  int iterations;

  // Optional sorting functions
  int Function(SankeyNode a, SankeyNode b)? nodeSort;
  int Function(SankeyLink a, SankeyLink b)? linkSort;

  /// Creates a [Sankey] layout generator with customizable
  /// bounds, node sizing, alignment, and iteration count
  ///
  /// If no [align] function is provided, it defaults to [sankeyJustify]
  Sankey({
    this.x0 = 0,
    this.y0 = 0,
    this.x1 = 1,
    this.y1 = 1,
    this.nodeWidth = 24,
    this.nodePadding = 8,
    NodeAlign? align,
    this.iterations = 6,
    this.nodeSort,
    this.linkSort,
  }) : align = align ?? sankeyJustify;

  /// Computes the layout for the given [nodes] and [links] and returns a
  /// [SankeyGraph] containing the computed positions
  ///
  /// The layout algorithm performs internal steps such as establishing node links,
  /// computing node values, assigning depths and heights, distributing nodes
  /// horizontally and vertically, and finally computing link positions
  SankeyGraph layout(List<SankeyNode> nodes, List<SankeyLink> links) {
    _computeNodeLinks(nodes, links);
    _computeNodeValues(nodes);
    _computeNodeDepths(nodes);
    _computeNodeHeights(nodes);
    _computeNodeBreadths(nodes);
    _computeLinkBreadths(nodes);
    return SankeyGraph(nodes: nodes, links: links);
  }

  /// Initializes each node's source and target links
  ///
  /// This function loops over every node to reset its link lists
  /// then assigns each link to its corresponding source and target nodes
  void _computeNodeLinks(List<SankeyNode> nodes, List<SankeyLink> links) {
    // Initialize each node’s sourceLinks and targetLinks.
    for (int i = 0; i < nodes.length; i++) {
      nodes[i].index = i;
      nodes[i].sourceLinks = [];
      nodes[i].targetLinks = [];
    }
    // For each link, add it to the respective source and target nodes
    for (int i = 0; i < links.length; i++) {
      SankeyLink link = links[i];
      link.index = i;
      // Assume that source and target are already SankeyNodes
      SankeyNode source = link.source is SankeyNode
          ? link.source as SankeyNode
          : throw Exception("Link source is not a SankeyNode");
      SankeyNode target = link.target is SankeyNode
          ? link.target as SankeyNode
          : throw Exception("Link target is not a SankeyNode");
      source.sourceLinks.add(link);
      target.targetLinks.add(link);
    }
    // Optionally sort links if a sort function is provided
    if (linkSort != null) {
      for (SankeyNode node in nodes) {
        node.sourceLinks.sort(linkSort);
        node.targetLinks.sort(linkSort);
      }
    }
  }

  /// Computes node values by summing the incoming and outgoing link values
  ///
  /// For each node, if a fixed value is provided via [fixedValue], it is used;
  /// otherwise, the node's value is set to the maximum of the sum of its source links
  /// or target links. This ensures that the node's rendered size reflects the
  /// largest flow through it
  void _computeNodeValues(List<SankeyNode> nodes) {
    for (SankeyNode node in nodes) {
      if (node.fixedValue != null) {
        node.value = node.fixedValue!;
      } else {
        double sumSource =
            node.sourceLinks.fold(0.0, (prev, link) => prev + link.value);
        double sumTarget =
            node.targetLinks.fold(0.0, (prev, link) => prev + link.value);
        node.value = max(sumSource, sumTarget);
      }
    }
  }

  /// Assigns a horizontal depth to each node using a breadth-first search
  ///
  /// Nodes are processed level by level, starting with the initial list
  /// A node's depth represents its horizontal distance from the source
  /// If a circular dependency is detected, an exception is thrown
  void _computeNodeDepths(List<SankeyNode> nodes) {
    int n = nodes.length;
    List<SankeyNode> current = List.from(nodes);
    List<SankeyNode> next = [];
    int depth = 0;
    while (current.isNotEmpty) {
      for (SankeyNode node in current) {
        node.depth = depth;
        for (SankeyLink link in node.sourceLinks) {
          SankeyNode target = link.target as SankeyNode;
          if (!next.contains(target)) {
            next.add(target);
          }
        }
      }
      depth++;
      if (depth > n) {
        throw Exception("Circular link detected in computeNodeDepths");
      }
      current = List.from(next);
      next.clear();
    }
  }

  /// Computes the height (reverse depth) of each node via a reverse
  /// breadth-first search using incoming links
  ///
  /// The height represents the distance from the node to a sink
  /// If a circular dependency is detected, an exception is thrown
  void _computeNodeHeights(List<SankeyNode> nodes) {
    int n = nodes.length;
    List<SankeyNode> current = List.from(nodes);
    List<SankeyNode> next = [];
    int height = 0;
    while (current.isNotEmpty) {
      for (SankeyNode node in current) {
        node.height = height;
        for (SankeyLink link in node.targetLinks) {
          SankeyNode source = link.source as SankeyNode;
          if (!next.contains(source)) {
            next.add(source);
          }
        }
      }
      height++;
      if (height > n) {
        throw Exception("Circular link detected in computeNodeHeights");
      }
      current = List.from(next);
      next.clear();
    }
  }

  /// Computes the columns (or layers) of nodes based on their horizontal position
  ///
  /// The maximum depth is computed and each node is assigned a layer value using
  /// the provided [align] function. Horizontal positions [x0] and [x1] are then
  /// calculated for each node. Optionally, nodes can be sorted using [nodeSort]
  List<List<SankeyNode>> _computeNodeLayers(List<SankeyNode> nodes) {
    // Determine the maximum depth
    int maxDepth = nodes.map((node) => node.depth).reduce(max) + 1;
    // Compute horizontal spacing
    double kx = maxDepth > 1 ? (x1 - x0 - nodeWidth) / (maxDepth - 1) : 0;
    List<List<SankeyNode>> columns = List.generate(maxDepth, (_) => []);
    for (SankeyNode node in nodes) {
      int layer = align(node, maxDepth);
      layer = layer.clamp(0, maxDepth - 1);
      node.layer = layer;
      node.x0 = x0 + layer * kx;
      node.x1 = node.x0 + nodeWidth;
      columns[layer].add(node);
    }
    if (nodeSort != null) {
      for (List<SankeyNode> column in columns) {
        column.sort(nodeSort);
      }
    }
    return columns;
  }

  /// Computes the vertical positions and sizes of nodes
  ///
  /// This method first computes the vertical scaling factor `ky` for each column,
  /// then assigns positions [y0] and [y1] to each node accordingly. It also computes
  /// the width of each link based on the scaling factor. Finally, extra spacing is added
  /// and node links are reordered to match the behavior of d3‑sankey
  void _initializeNodeBreadths(List<List<SankeyNode>> columns) {
    // Determine the vertical scaling factor (ky)
    double ky = double.infinity;
    for (List<SankeyNode> column in columns) {
      double columnSum = column.fold(0.0, (prev, node) => prev + node.value);
      if (column.isNotEmpty) {
        ky = min(ky, (y1 - y0 - (column.length - 1) * nodePadding) / columnSum);
      }
    }
    // Position each node vertically
    for (List<SankeyNode> column in columns) {
      double y = y0;
      for (SankeyNode node in column) {
        node.y0 = y;
        node.y1 = y + node.value * ky;
        y = node.y1 + nodePadding;
        // Set the computed link widths
        for (SankeyLink link in node.sourceLinks) {
          link.width = link.value * ky;
        }
      }
      // Add extra vertical spacing
      double spacing = (y1 - y + nodePadding) / (column.length + 1);
      for (int i = 0; i < column.length; i++) {
        column[i].y0 += spacing * (i + 1);
        column[i].y1 += spacing * (i + 1);
      }
      // Reorder node links to match the JS implementation
      _reorderLinks(column);
    }
  }

  /// Computes the final vertical positions of nodes (node breadths) and
  /// performs iterative relaxation to minimize overlap
  ///
  /// Nodes are first assigned to columns (layers) and then positioned using
  /// [_initializeNodeBreadths]. Iterative relaxation is applied to adjust nodes
  /// from left-to-right and right-to-left for a balanced layout
  void _computeNodeBreadths(List<SankeyNode> nodes) {
    List<List<SankeyNode>> columns = _computeNodeLayers(nodes);
    int maxNodes = columns.map((col) => col.length).reduce(max);
    double effectiveNodePadding = min(nodePadding, (y1 - y0) / (maxNodes - 1));
    nodePadding = effectiveNodePadding;
    _initializeNodeBreadths(columns);
    // Apply iterative relaxation.
    for (int i = 0; i < iterations; i++) {
      double alpha = pow(0.99, i).toDouble();
      double beta = max(1 - alpha, (i + 1) / iterations);
      _relaxRightToLeft(columns, alpha, beta);
      _relaxLeftToRight(columns, alpha, beta);
    }
  }

  /// Computes the vertical positions for links based on the positions of the nodes
  ///
  /// For each node, this method calculates the starting position [y0] for outgoing links
  /// and the ending position [y1] for incoming links, adjusting for the link width
  void _computeLinkBreadths(List<SankeyNode> nodes) {
    for (SankeyNode node in nodes) {
      double offset = node.y0;
      for (SankeyLink link in node.sourceLinks) {
        link.y0 = offset + link.width / 2;
        offset += link.width;
      }
      offset = node.y0;
      for (SankeyLink link in node.targetLinks) {
        link.y1 = offset + link.width / 2;
        offset += link.width;
      }
    }
  }

  /// Performs relaxation of node positions from left to right
  ///
  /// For each node (except those in the first column), adjusts the vertical position
  /// based on the weighted average of the positions of the nodes in the previous column
  /// Then, it resolves any collisions that result
  void _relaxLeftToRight(
      List<List<SankeyNode>> columns, double alpha, double beta) {
    for (int i = 1; i < columns.length; i++) {
      for (SankeyNode target in columns[i]) {
        double ySum = 0;
        double weightSum = 0;
        for (SankeyLink link in target.targetLinks) {
          SankeyNode source = link.source as SankeyNode;
          double idealY = _targetTop(source, target);
          double weight = link.value * (target.layer - source.layer);
          ySum += idealY * weight;
          weightSum += weight;
        }
        if (weightSum > 0) {
          double dy = (ySum / weightSum - target.y0) * alpha;
          target.y0 += dy;
          target.y1 += dy;
          _reorderNodeLinks(target);
        }
      }
      if (nodeSort == null) {
        columns[i].sort((a, b) => a.y0.compareTo(b.y0));
      }
      _resolveCollisions(columns[i], beta);
    }
  }

  /// Performs relaxation of node positions from right to left
  ///
  /// Adjusts the vertical positions for nodes in earlier columns based on their
  /// source nodes in later columns, then resolves collisions
  void _relaxRightToLeft(
      List<List<SankeyNode>> columns, double alpha, double beta) {
    for (int i = columns.length - 2; i >= 0; i--) {
      for (SankeyNode source in columns[i]) {
        double ySum = 0;
        double weightSum = 0;
        for (SankeyLink link in source.sourceLinks) {
          SankeyNode target = link.target as SankeyNode;
          double idealY = _sourceTop(source, target);
          double weight = link.value * (target.layer - source.layer);
          ySum += idealY * weight;
          weightSum += weight;
        }
        if (weightSum > 0) {
          double dy = (ySum / weightSum - source.y0) * alpha;
          source.y0 += dy;
          source.y1 += dy;
          _reorderNodeLinks(source);
        }
      }
      if (nodeSort == null) {
        columns[i].sort((a, b) => a.y0.compareTo(b.y0));
      }
      _resolveCollisions(columns[i], beta);
    }
  }

  /// Resolves collisions among nodes within a column
  ///
  /// This method checks and adjusts the positions of nodes in a column so that they
  /// do not overlap. It does so by processing nodes both from the middle outward and by
  /// applying adjustments top-to-bottom and bottom-to-top
  void _resolveCollisions(List<SankeyNode> column, double alpha) {
    if (column.isEmpty) return;
    int mid = column.length ~/ 2;
    _resolveCollisionsBottomToTop(
        column, column[mid].y0 - nodePadding, mid - 1, alpha);
    _resolveCollisionsTopToBottom(
        column, column[mid].y1 + nodePadding, mid + 1, alpha);
    _resolveCollisionsBottomToTop(column, y1, column.length - 1, alpha);
    _resolveCollisionsTopToBottom(column, y0, 0, alpha);
  }

  /// Adjusts node positions from top downwards to resolve collisions
  void _resolveCollisionsTopToBottom(
      List<SankeyNode> column, double y, int startIndex, double alpha) {
    for (int i = startIndex; i < column.length; i++) {
      SankeyNode node = column[i];
      double dy = (y - node.y0) * alpha;
      if (dy > 1e-6) {
        node.y0 += dy;
        node.y1 += dy;
      }
      y = node.y1 + nodePadding;
    }
  }

  /// Adjusts node positions from bottom upwards to resolve collisions
  void _resolveCollisionsBottomToTop(
      List<SankeyNode> column, double y, int startIndex, double alpha) {
    for (int i = startIndex; i >= 0; i--) {
      SankeyNode node = column[i];
      double dy = (node.y1 - y) * alpha;
      if (dy > 1e-6) {
        node.y0 -= dy;
        node.y1 -= dy;
      }
      y = node.y0 - nodePadding;
    }
  }

  /// Reorders the links for the given node based on the vertical positions
  /// of connected nodes
  ///
  /// For consistency with d3‑sankey:
  /// - [sourceLinks] are sorted by the [y0] of their target nodes
  /// - [targetLinks] are sorted by the [y0] of their source nodes
  /// In the event of a tie, the link's index is used as a tie-breaker
  void _reorderNodeLinks(SankeyNode node) {
    if (linkSort == null) {
      node.sourceLinks.sort((a, b) {
        int cmp =
            (a.target as SankeyNode).y0.compareTo((b.target as SankeyNode).y0);
        return cmp != 0 ? cmp : a.index.compareTo(b.index);
      });
      node.targetLinks.sort((a, b) {
        int cmp =
            (a.source as SankeyNode).y0.compareTo((b.source as SankeyNode).y0);
        return cmp != 0 ? cmp : a.index.compareTo(b.index);
      });
    }
  }

  /// Reorders links for all nodes in the given column
  ///
  /// This ensures that the ordering of link offsets is consistent
  /// with the behavior of d3‑sankey
  void _reorderLinks(List<SankeyNode> nodes) {
    if (linkSort == null) {
      for (SankeyNode node in nodes) {
        node.sourceLinks.sort((a, b) {
          int cmp = (a.target as SankeyNode)
              .y0
              .compareTo((b.target as SankeyNode).y0);
          return cmp != 0 ? cmp : a.index.compareTo(b.index);
        });
        node.targetLinks.sort((a, b) {
          int cmp = (a.source as SankeyNode)
              .y0
              .compareTo((b.source as SankeyNode).y0);
          return cmp != 0 ? cmp : a.index.compareTo(b.index);
        });
      }
    }
  }

  /// Calculates the ideal starting vertical position for links leaving a source node
  /// connecting to the specified target node
  ///
  /// This is computed by starting from the source node's top position, adjusting
  /// for the link widths and padding until the target node is reached
  double _targetTop(SankeyNode source, SankeyNode target) {
    double y = source.y0 - (source.sourceLinks.length - 1) * nodePadding / 2;
    for (SankeyLink link in source.sourceLinks) {
      SankeyNode t = link.target as SankeyNode;
      if (t == target) break;
      y += link.width + nodePadding;
    }
    for (SankeyLink link in target.targetLinks) {
      SankeyNode s = link.source as SankeyNode;
      if (s == source) break;
      y -= link.width;
    }
    return y;
  }

  /// Calculates the ideal starting vertical position for links entering a target node
  /// from the specified source node
  ///
  /// This is computed by starting from the target node's top position and adjusting
  /// for the widths of incoming links, ensuring a visually balanced position
  double _sourceTop(SankeyNode source, SankeyNode target) {
    double y = target.y0 - (target.targetLinks.length - 1) * nodePadding / 2;
    for (SankeyLink link in target.targetLinks) {
      SankeyNode s = link.source as SankeyNode;
      if (s == source) break;
      y += link.width + nodePadding;
    }
    for (SankeyLink link in source.sourceLinks) {
      SankeyNode t = link.target as SankeyNode;
      if (t == target) break;
      y -= link.width;
    }
    return y;
  }
}

/// A simple container for the computed Sankey diagram graph
///
/// The [SankeyGraph] holds the list of nodes and links after the layout
/// generator has computed their positions and dimensions
class SankeyGraph {
  /// The list of positioned Sankey nodes
  final List<SankeyNode> nodes;

  /// The list of Sankey links with computed geometries
  final List<SankeyLink> links;

  SankeyGraph({required this.nodes, required this.links});
}