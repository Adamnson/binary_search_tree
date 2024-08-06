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
    # if it is a leaf node, remove
    # if it is an intermediate node, remove and reassign
    # if it the root node?

    next_node = node.value > element ? node.left : node.right
    return if next_node.nil?

    if next_node.value.eql?(element)
      next_node < node ? node.left = nil : node.right = nil
    else
      delete(element, next_node)
    end
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

t1.delete(67)
t1.pretty_print
t1.delete(7)
t1.pretty_print
