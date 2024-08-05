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
    @root = build_tree(arr, arr.size)
  end

  def build_tree(arr, size)
    return Node.new(arr[0]) if size < 2

    arr = arr.sort
    mid = (arr.size / 2).floor
    left = arr[0..(mid - 1)]
    right = arr[(mid + 1)..]
    Node.new(arr[mid],
             build_tree(left, left.size),
             build_tree(right, right.size))
  end

  def pretty_print(node = @root, prefix = "", is_left: true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) unless node.right.nil?
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.value}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) unless node.left.nil?
  end
end

# t1 = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])
t1 = Tree.new([1, 7, 4, 23, 8])

p t1
pp t1
