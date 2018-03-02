describe PillarKata::VendingItem do
  before do
    @cola = PillarKata::VendingItem.new("cola", 1.00)
  end

  describe "#initialize" do
    it "assigns name to @name" do
      expect(@cola.name).to eq "cola"
    end

    it "assigns price to @price" do
      expect(@cola.price).to eq 1.00
    end
  end
end