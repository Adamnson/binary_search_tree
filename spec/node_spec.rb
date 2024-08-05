require './lib/main.rb'

describe Node do
  describe "#initialize" do
    it "creates a new node with nil value" do
      node = Node.new
      expect(node.value).to eql(nil)
    end
  end
end