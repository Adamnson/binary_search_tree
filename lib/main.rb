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
class Tree # rubocop:disable Metrics/ClassLength
  attr_accessor :root
  attr_reader :level_order_q, :in_order_q, :pre_order_q, :post_order_q

  def initialize(arr)
    @root = build_tree(arr)
    @level_order_q = [@root]
    @loq_index = 0
    @in_order_q = []
    @pre_order_q = []
    @post_order_q = []
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

    return delete_node_with_left_and_right(@root) if @root.value.eql?(element)

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

  def delete_node_with_left_and_right(node, next_node = node)
    in_order_successor = next_node.right
    if in_order_successor.left.nil?
      in_order_successor.left = next_node.left
      next_node < node ? node.left = in_order_successor : node.right = in_order_successor
    else
      reached_leaf_node = in_order_successor.left.left.nil? && in_order_successor.left.right.nil?
      in_order_successor = in_order_successor.left until reached_leaf_node
      swap(next_node, in_order_successor)
      in_order_successor.left = nil
    end
  end

  def swap(node_a, node_b)
    node_a.value += node_b.left.value
    node_b.left.value = node_a.value - node_b.left.value
    node_a.value -= node_b.left.value
  end

  def find(val, node = @root)
    return node if node.value.eql?(val)

    if val < node.value && !node.left.nil?
      find(val, node.left)
    elsif val > node.value && !node.right.nil?
      find(val, node.right)
    end
  end

  def level_order_rec(node = @root)
    return if node.left.nil? && node.right.nil?

    @level_order_q.append(node.left) unless node.left.nil?
    @level_order_q.append(node.right) unless node.right.nil?
    @loq_index += 1
    node = @level_order_q[@loq_index]
    level_order_rec(node)
    @level_order_q
  end

  def in_order(node = @root, clear: true)
    @in_order_q = [] if clear
    return @in_order_q.append(node) if node.left.nil? && node.right.nil?

    in_order(node.left, clear: false) unless node.left.nil?
    @in_order_q.append(node)
    return if node.right.nil?

    in_order(node.right, clear: false)

    @in_order_q
  end

  def pre_order(node = @root, clear: true)
    @pre_order_q = [] if clear
    return @pre_order_q.append(node) if node.left.nil? && node.right.nil?

    @pre_order_q.append(node)
    pre_order(node.left, clear: false) unless node.left.nil?
    pre_order(node.right, clear: false) unless node.right.nil?

    @pre_order_q
  end

  def post_order(node = @root, clear: true)
    @post_order_q = [] if clear
    return @post_order_q.append(node) if node.left.nil? && node.right.nil?

    post_order(node.left, clear: false) unless node.left.nil?
    post_order(node.right, clear: false) unless node.right.nil?
    @post_order_q.append(node)

    @post_order_q
  end

  def height(node = @root)
    return 0 if node.left.nil? && node.right.nil?

    left = right = 0

    left = height(node.left) unless node.left.nil?
    right = height(node.right) unless node.right.nil?

    [left + 1, right + 1].max
  end

  def depth(node = @root)
    height(@root) - height(node)
  end

  def balanced?(node = @root, flag: false)
    return false if flag

    return true if node.left.nil? && node.right.nil?

    puts "left: #{node.left.value} right: #{node.right.value}"

    left_score = node.left.nil? ? -1 : height(node.left)
    right_score = node.right.nil? ? -1 : height(node.right)
    flag = (left_score - right_score).abs > 1
    !flag && (balanced?(node.left) && balanced?(node.right))
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
############################################
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

# puts t1.find(5)

# puts t1.find(39)
############################################
# in_ord_q = t1.in_order

# in_ord_q.each { |e| print "#{e.value} " }
# puts " "

# t1.delete(67)
# t1.pretty_print

# t1.delete(8)
# t1.pretty_print

############################################
# pre_ord_q = t1.pre_order
# post_ord_q = t1.post_order

# puts "pre order: "
# pre_ord_q.each { |e| print "#{e.value} " }
# puts " "

# puts "post order: "
# post_ord_q.each { |e| print "#{e.value} " }
# puts " "

# t1.delete(67)
# t1.pretty_print

# t1.delete(8)
# t1.pretty_print

# puts "after deletions"
# pre_ord_q = t1.pre_order
# post_ord_q = t1.post_order

# puts "pre order: "
# pre_ord_q.each { |e| print "#{e.value} " }
# puts " "

# puts "post order: "
# post_ord_q.each { |e| print "#{e.value} " }
# puts " "

test_arr2 = [1, 7, 4, 23, 8]
test_arr3 = [1, 7, 4, 23, 3, 15, 8]

t2 = Tree.new(test_arr2)
t3 = Tree.new(test_arr3)

# t2.pretty_print
# t3.pretty_print

puts "height from root is #{t1.height}"
puts "height from 67 is #{t1.height(t1.find(67))}"
puts "height of 79 is #{t1.height(t1.find(79))}"

# t1.delete(7)
# t1.delete(5)
t1.delete(8)

t1.pretty_print
puts t1.balanced?(t1.root.left)
puts t1.balanced?
