require "./lib/main"

describe Node do # rubocop:disable Metrics/BlockLength
  context "#initialize with nil" do
    node = Node.new

    it "creates a new node with nil value" do
      expect(node.value).to eql(nil)
    end

    it "creates a new node with nil left" do
      expect(node.left).to eql(nil)
    end

    it "creates a new node with nil right" do
      expect(node.right).to eql(nil)
    end
  end

  context "#initialize only with value" do
    node = Node.new("test")

    it "creates a new node with given value" do
      expect(node.value).to eql("test")
    end

    it "created a new node with left nil" do
      expect(node.left).to eql(nil)
    end

    it "creates a new node with right nil" do
      expect(node.right).to eql(nil)
    end
  end

  context "#initialize with value and left node" do
    node1 = Node.new("child")
    node2 = Node.new("parent", node1)

    it "creates a new node with given value" do
      expect(node2.value).to eql("parent")
    end

    it "creates a new node with a left node" do
      expect(node2.left).to be(node1)
    end

    it "retains the value of the left node" do
      expect(node2.left.value).to eql("child")
    end
  end

  context "#initialize with value and both nodes" do
    node_l = Node.new("left")
    node_r = Node.new("right")
    node   = Node.new("parent", node_l, node_r)

    it "creates a new node with a left node" do
      expect(node.left).to be(node_l)
    end

    it "created a new node with a right node" do
      expect(node.right).to be(node_r)
    end

    it "retains the value of the left node" do
      expect(node.left.value).to eql("left")
    end

    it "retians the value of the right node" do
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
  end
end
