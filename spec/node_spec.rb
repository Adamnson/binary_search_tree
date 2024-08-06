require "./lib/main"

describe Node do # rubocop:disable Metrics/BlockLength
  context "#initialize with nil" do
    node = Node.new

    it "creates a new node with nil value" do
      expect(node.value).to eql(nil)
      expect(node.left).to eql(nil)
      expect(node.right).to eql(nil)
    end
  end

  context "#initialize only with value" do
    node = Node.new("test")

    it "creates a new node with given value" do
      expect(node.value).to eql("test")
      expect(node.left).to eql(nil)
      expect(node.right).to eql(nil)
    end
  end

  context "#initialize with value and left node" do
    node1 = Node.new("child")
    node2 = Node.new("parent", node1)

    it "creates a new node with given value" do
      expect(node2.value).to eql("parent")
      expect(node2.left).to be(node1)
      expect(node2.left.value).to eql("child")
    end
  end

  context "#initialize with value and both nodes" do
    node_l = Node.new("left")
    node_r = Node.new("right")
    node   = Node.new("parent", node_l, node_r)

    it "creates a new node with a left node" do
      expect(node.left).to be(node_l)
      expect(node.right).to be(node_r)
      expect(node.left.value).to eql("left")
      expect(node.right.value).to eql("right")
    end
  end

  context "compare nodes based on value" do
    it "compares two nodes on the basis of thier values (int)" do
      node1 = Node.new(5)
      node2 = Node.new(15)
      expect(node1 <=> node2).to eql(-1)
    end

    it "compares two nodes on the basis of thier values (string)" do
      node1 = Node.new("Paul")
      node2 = Node.new("Chris")
      expect(node1 <=> node2).to eql(1)
    end

    n1 = Node.new("Z")
    n2 = Node.new("YY")
    n3 = Node.new("XXX")
    n4 = Node.new("WWWW")
    n5 = Node.new("VVVVV")
    puts "sorted: #{[n3, n2, n5, n4, n1].sort}"

    it "checks if a value lies in between two other values" do
      expect(n4.between?(n1, n3)).to be(false)
      expect(n4.between?(n5, n3)).to be(true)
    end

    it "sorts the nodes based on their values" do
      expect([n3, n2, n5, n4, n1].sort).to eql([n5, n4, n3, n2, n1])
    end
  end
end
