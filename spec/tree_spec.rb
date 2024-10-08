require "./lib/main"

describe Tree do # rubocop:disable Metrics/BlockLength
  test_arr1 = [1, 7, 4, 23, 8, 27, 79, 111, 47, 9, 4, 3, 5, 7, 9, 67, 6345, 324]
  test_arr2 = [1, 7, 4, 23, 8]
  test_arr3 = [1, 7, 4, 23, 3, 15, 8]
  context "#insert" do
    it "returns nil if element is root" do
      t1 = Tree.new(test_arr1)
      res = t1.insert(8)
      expect(res).to eql(nil)
    end

    it "returns nil if element exists in the tree" do
      t1 = Tree.new(test_arr1)
      res = t1.insert(67)
      expect(res).to eql(nil)
    end

    it "adds a new node at the end of the tree" do
      t1 = Tree.new(test_arr2)
      expect(t1.root.left.right).to be(nil)
      t1.insert(5)
      expect(t1.root.left.right.value).to eql(5)
    end
  end

  context "#delete" do
    it "deletes the leaf node" do
      t1 = Tree.new(test_arr1)
      expect(t1.root.right.left.right.value).to eql(67)
      expect(t1.root.left.right.left.value).to eql(7)
      t1.delete(67) # check right node deletion
      expect(t1.root.right.left.right).to eql(nil)
      t1.delete(7) # check left node deletion
      expect(t1.root.left.right.left).to eql(nil)
    end

    it "deletes an intermediate node" do
      t1 = Tree.new(test_arr1)
      expect(t1.root.right.value).to eql(79)
      expect(t1.root.right.right.value).to eql(324)
      expect(t1.root.right.right.left.value).to eql(111)
      expect(t1.root.right.left.value).to eql(47)
      t1.delete(79)
      expect(t1.root.right.value).to eql(111)
      expect(t1.root.right.right.value).to eql(324)
      expect(t1.root.right.right.left).to eql(nil)
      expect(t1.root.right.left.value).to eql(47)
    end
  end
  context "#leaf_node?" do # rubocop:disable Metrics/BlockLength
    it "is true if node is the leaf node" do
      t1 = Tree.new(test_arr1)
      expect(t1.leaf_node?(t1.find(1))).to be true
      expect(t1.leaf_node?(t1.find(4))).to be true
      expect(t1.leaf_node?(t1.find(7))).to be true
      expect(t1.leaf_node?(t1.find(9))).to be true
      expect(t1.leaf_node?(t1.find(27))).to be true
      expect(t1.leaf_node?(t1.find(67))).to be true
      expect(t1.leaf_node?(t1.find(111))).to be true
      expect(t1.leaf_node?(t1.find(6345))).to be true
    end

    it "is false for intermediate nodes" do
      t1 = Tree.new(test_arr1)
      expect(t1.leaf_node?(t1.find(3))).to be false
      expect(t1.leaf_node?(t1.find(8))).to be false
      expect(t1.leaf_node?(t1.find(47))).to be false
      expect(t1.leaf_node?(t1.find(324))).to be false
      expect(t1.leaf_node?(t1.find(5))).to be false
      expect(t1.leaf_node?(t1.find(79))).to be false
      expect(t1.leaf_node?(t1.find(23))).to be false
    end

    it "does not falsely classify single children nodes" do
      t1 = Tree.new(test_arr2)
      expect(t1.leaf_node?(t1.find(1))).to be true
      expect(t1.leaf_node?(t1.find(8))).to be true
      expect(t1.leaf_node?(t1.find(23))).to be false
      expect(t1.leaf_node?(t1.find(4))).to be false
    end

    it "is true for nil input" do
      t1 = Tree.new(test_arr1)
      expect(t1.leaf_node?(nil)).to be true
    end
  end

  context "#find" do
    t1 = Tree.new(test_arr1)
    it "retruns the node containing the value, if exists" do
      node = t1.find(111)
      expect(node.value).to eql(111)
    end

    it "return nil if the value was not found" do
      node = t1.find(36)
      expect(node).to be_nil
    end

    it "finds and returns the root element correctly" do
      node = t1.find(23)
      expect(node).to eql(t1.root)
    end
  end

  context "#level_order_rec" do # rubocop:disable Metrics/BlockLength
    t1 = Tree.new(test_arr3)
    expected = [t1.root, t1.root.left, t1.root.right,
                t1.root.left.left, t1.root.left.right,
                t1.root.right.left, t1.root.right.right]

    it "returns an array with all nodes traversed " do
      expect(t1.level_order_q).to eql([t1.root])
      t1.level_order_rec
      expect(t1.level_order_q).to eql(expected)
    end

    it "contains root + right children on even index positions" do
      t1 = Tree.new(test_arr1)
      evens = t1.level_order_rec.filter.each_with_index { |e, i| e.value if i.even? }
      exp = [t1.root,
             t1.root.right,
             t1.root.left.right, t1.root.right.right,
             t1.root.left.left.right, t1.root.left.right.right, t1.root.right.left.right, t1.root.right.right.right]
      expect(evens).to eql(exp)
    end

    it "contains left children on odd index positions" do
      t1 = Tree.new(test_arr1)
      odds = t1.level_order_rec.filter.each_with_index { |e, i| e.value if i.odd? }
      exp = [t1.root.left,
             t1.root.left.left, t1.root.right.left,
             t1.root.left.left.left, t1.root.left.right.left, t1.root.right.left.left, t1.root.right.right.left]
      expect(odds).to eql(exp)
    end
  end

  context "#in_order (left-->root-->right)" do
    it "returns elements in the ascending order" do
      t1 = Tree.new(test_arr1)
      expect(t1.in_order_q).to eql([])
      vals = t1.in_order.map(&:value)
      expect(vals).to eql(test_arr1.uniq.sort)
    end

    it "traverses in order from specified node" do
      t1 = Tree.new(test_arr1)
      exp = [27, 47, 67, 79, 111, 324, 6345]
      expect(t1.in_order_q).to eql([])
      vals = t1.in_order(t1.root.right).map(&:value)
      expect(vals).to eql(exp)
    end
  end

  context "#pre_order (root-->left-->right)" do
    it "updates the @pre_order_q " do
      t1 = Tree.new(test_arr3)
      exp = [7, 3, 1, 4, 15, 8, 23]
      exp1 = [t1.root,
              t1.root.left, t1.root.left.left, t1.root.left.right,
              t1.root.right, t1.root.right.left, t1.root.right.right]
      expect(t1.pre_order_q).to eql([])
      t1.pre_order
      expect(t1.pre_order_q.map(&:value)).to eql(exp)
      expect(t1.pre_order_q).to eql(exp1)
    end

    it "traverses pre order from specified node" do
      t1 = Tree.new(test_arr1)
      exp = [79, 47, 27, 67, 324, 111, 6345]
      expect(t1.pre_order_q).to eql([])
      t1.pre_order(t1.root.right)
      expect(t1.pre_order_q.map(&:value)).to eql(exp)
    end
  end

  context "#post_order (left-->right-->root)" do
    it "updates the @post_order_q " do
      t1 = Tree.new(test_arr3)
      exp = [1, 4, 3, 8, 23, 15, 7]
      exp1 = [t1.root.left.left, t1.root.left.right, t1.root.left,
              t1.root.right.left, t1.root.right.right, t1.root.right,
              t1.root]
      expect(t1.post_order_q).to eql([])
      t1.post_order
      expect(t1.post_order_q.map(&:value)).to eql(exp)
      expect(t1.post_order_q).to eql(exp1)
    end

    it "traverses post order from specified node" do
      t1 = Tree.new(test_arr1)
      exp = [27, 67, 47, 111, 6345, 324, 79]
      expect(t1.post_order_q).to eql([])
      t1.post_order(t1.root.right)
      expect(t1.post_order_q.map(&:value)).to eql(exp)
    end
  end

  context "#height" do
    it "is 0 for leaf nodes" do
      t1 = Tree.new(test_arr1)
      expect(t1.height(t1.find(1))).to eql(0)
      expect(t1.height(t1.find(4))).to eql(0)
      expect(t1.height(t1.find(7))).to eql(0)
      expect(t1.height(t1.find(9))).to eql(0)
      expect(t1.height(t1.find(27))).to eql(0)
      expect(t1.height(t1.find(67))).to eql(0)
      expect(t1.height(t1.find(111))).to eql(0)
      expect(t1.height(t1.find(6345))).to eql(0)
    end

    it "assigns correct values" do
      t1 = Tree.new(test_arr1)
      expect(t1.height(t1.root)).to eql(3)
      expect(t1.height(t1.root.left)).to eql(2)
      expect(t1.height(t1.root.right)).to eql(2)
      expect(t1.height(t1.root.left.left)).to eql(1)
      expect(t1.height(t1.root.left.right)).to eql(1)
      expect(t1.height(t1.root.right.left)).to eql(1)
      expect(t1.height(t1.root.right.right)).to eql(1)
    end

    it "is -1 for nil input (from find)" do
      t1 = Tree.new(test_arr3)
      expect(t1.height(t1.find(55))).to eql(-1)
    end
  end

  context "#depth" do
    t1 = Tree.new(test_arr1)
    it "is 0 for @root" do
      expect(t1.depth(t1.root)).to eql(0)
    end

    it "is -1 for nil input (from find)" do
      expect(t1.depth(t1.find(55))).to eql(-1)
    end

    it "assigns correct values" do
      expect(t1.depth(t1.root.left)).to eql(1)
      expect(t1.depth(t1.root.right)).to eql(1)
      expect(t1.depth(t1.root.left.left)).to eql(2)
      expect(t1.depth(t1.root.left.right)).to eql(2)
      expect(t1.depth(t1.root.right.left)).to eql(2)
      expect(t1.depth(t1.root.right.right)).to eql(2)
      expect(t1.depth(t1.find(1))).to eql(3)
      expect(t1.depth(t1.find(4))).to eql(3)
      expect(t1.depth(t1.find(7))).to eql(3)
      expect(t1.depth(t1.find(9))).to eql(3)
      expect(t1.depth(t1.find(27))).to eql(3)
      expect(t1.depth(t1.find(67))).to eql(3)
      expect(t1.depth(t1.find(111))).to eql(3)
      expect(t1.depth(t1.find(6345))).to eql(3)
    end
  end

  context "#balanced?" do # rubocop:disable Metrics/BlockLength
    it "is false if flag is true" do
      t1 = Tree.new(test_arr1)
      expect(t1.balanced?(t1.root, flag: true)).to be false
    end

    it "is true if tree is perfectly balanced" do
      t1 = Tree.new(test_arr3)
      left_height = t1.height(t1.root.left)
      right_height = t1.height(t1.root.right)
      expect(t1.balanced?).to be true
      expect(left_height).to eql(right_height)
    end

    it "is true of tree is improperly balanced" do
      t1 = Tree.new(test_arr1)
      t1.delete(7)
      t1.delete(8)
      left_left_height = t1.height(t1.root.left.left)
      left_right_height = t1.height(t1.root.left.right)
      expect(t1.balanced?).to be true
      expect(left_left_height).to_not eql(left_right_height)
      expect(left_left_height).to be_within(1).of(left_right_height)
    end

    it "is false if tree is not balanced" do
      t1 = Tree.new(test_arr1)
      t1.delete(7)
      t1.delete(8)
      t1.delete(5)
      left_left_height = t1.height(t1.root.left.left)
      left_right_height = t1.height(t1.root.left.right)
      expect(t1.balanced?).to be false
      expect(left_left_height).to_not eql(left_right_height)
      expect(left_left_height).to_not be_within(1).of(left_right_height)
    end
  end

  context "#rebalance" do
    it "rebalances the tree" do
      t1 = Tree.new(test_arr1)
      t1.delete(7)
      t1.delete(8)
      t1.delete(5)
      left_left_height = t1.height(t1.root.left.left)
      left_right_height = t1.height(t1.root.left.right)
      expect(t1.root.value).to eql(23)
      expect(t1.balanced?).to be false
      expect(left_left_height).to_not eql(left_right_height)
      expect(left_left_height).to_not be_within(1).of(left_right_height)
      t1.rebalance
      expect(t1.root.value).to eql(47)
      left_left_height = t1.height(t1.root.left.left)
      left_right_height = t1.height(t1.root.left.right)
      expect(t1.balanced?).to be true
      expect(left_left_height).to eql(left_right_height)
      expect(left_left_height).to be_within(1).of(left_right_height)
    end
  end
end
