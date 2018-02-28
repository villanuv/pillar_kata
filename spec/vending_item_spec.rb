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

    context "attr_accessor methods" do
      describe "#name" do
        it "gets and sets @name" do
          expect(@cola.name).to eq "cola"
          @cola.name = "coke"
          expect(@cola.name).to eq "coke"
        end
      end

      describe "#price" do
        it "gets and sets @price" do
          expect(@cola.price).to eq 1.00
          @cola.price = 1.25
          expect(@cola.price).to eq 1.25
        end
      end
    end
  end
end