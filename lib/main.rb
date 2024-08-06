# class Node implements a node as a basic unit of Tree class
# class variables:
#  @value
#  @left
#  @right
# class methods:
#  initialize
class Node
  include Comparable
  attr_accessor :left, :right, :value

  def <=>(other)
    @value <=> other.value
  end

  def initialize(val = nil, left = nil, right = nil)
    @value = val
    @left = left
    @right = right
  end
end

# class Tree builds a binary search tree based on the input array
#
#
class Tree
  attr_accessor :root

  def initialize(arr)
    @root = build_tree(arr)
  end

  def build_tree(arr)
    return Node.new(arr[0]) if arr.one?

    arr_cp = arr.uniq.sort
    mid, left, right = split_array(arr_cp)
    if right.nil?
      Node.new(arr_cp[mid], build_tree(left))
    else
      Node.new(arr_cp[mid], build_tree(left), build_tree(right))
    end
  end

  def split_array(arr)
    mid = (arr.size / 2)
    left = arr[0..(mid - 1)]
    right = arr[(mid + 1)..].empty? ? nil : arr[(mid + 1)..]
    [mid, left, right]
  end

  def insert(element, node = @root)
    return if element.eql?(node.value)

    next_node = element < node.value ? node.left : node.right
    if (node.left.nil? && node.right.nil?) || next_node.nil?
      new_node = Node.new(element)
      new_node < node ? node.left = new_node : node.right = new_node
    else
      insert(element, next_node)
    end
  end

  def delete(element, node = @root)
    next_node = node.value > element ? node.left : node.right
    return if next_node.nil?

    if next_node.value.eql?(element)
      delete_node_based_on_branching(node, next_node)
    else
      delete(element, next_node)
    end
  end

  def delete_node_based_on_branching(node, next_node) # rubocop:disable Metrics/CyclomaticComplexity,Metrics/PerceivedComplexity
    is_leaf_node = next_node.left.nil? && next_node.right.nil? # leaf_node_deletion
    has_only_left = next_node < node && next_node.right.nil? # deletion of node with single child
    has_only_right = next_node > node && next_node.left.nil? # deletion of node with single child
    if is_leaf_node
      next_node < node ? node.left = nil : node.right = nil
    elsif has_only_left
      node.left = next_node.left
    elsif has_only_right
      node.right = next_node.right
    else
      delete_node_with_left_and_right(node, next_node)
    end
  end

  def delete_node_with_left_and_right(node, next_node)
    in_order_successor = next_node.right
    if in_order_successor.left.nil?
      in_order_successor.left = next_node.left
      next_node < node ? node.left = in_order_successor : node.right = in_order_successor
    else
      in_order_successor = in_order_successor.left until in_order_successor.left.left.nil? && in_order_successor.left.right.nil?
      swap(next_node, in_order_successor)
      in_order_successor.left = nil
    end
  end

  def swap(node_a, node_b)
    node_a.value += node_b.left.value
    node_b.left.value = node_a.value - node_b.left.value
    node_a.value -= node_b.left.value
  end

  def pretty_print(node = @root, prefix = "", is_left: true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", is_left: false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", is_left: true) if node.left
  end
end

t1 = Tree.new([1, 7, 4, 23, 8, 27, 79, 111, 47, 9, 4, 3, 5, 7, 9, 67, 6345, 324])
# t1 = Tree.new([1, 7, 4, 23, 8])

# p t1.root
t1.pretty_print

# t1.insert(12)
# t1.insert(-11)
# t1.insert(57)
# t1.insert(39)
# puts t1.insert(5)

# t1.delete(67)
# t1.pretty_print
# t1.delete(7)
# t1.pretty_print
# t1.delete(8)
# t1.pretty_print

# t1.delete(79)
# t1.pretty_print
# t1.delete(5)
# t1.pretty_print

t1.delete(23)
t1.pretty_print
