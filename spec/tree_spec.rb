require "./lib/main"

describe Tree do
  context "#insert" do
    it "returns nil if element is root" do
      t1 = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])
      res = t1.insert(8)
      expect(res).to eql(nil)
    end

    it "returns nil if element exists in the tree" do
      t1 = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])
      res = t1.insert(67)
      expect(res).to eql(nil)
    end

    xit "adds a new node at the end of the tree" do
      t1 = Tree.new([1, 7, 4, 23, 8])
      expect(t1.root.left.right).to be(nil)
      t1.insert(5)
      expect(t1.root.left.right.value).to eql(5)
    end
  end
end
