require "spec_helper"

describe Building do
  let(:building) { create(:building) }

  it "has tenants" do
    2.times { building.tenants << create(:user) }
    expect(building.tenants.count).to eq(2)
  end

  describe "address validations" do
    let(:zip_code_error) { ["should be 12345 or 12345-1234"] }

    it "requires a street address and zip code" do
      expect(building).to be_valid
    end

    it "validates the presence of the street address" do
      building.update_attributes(street_address: nil)
      expect(building).to_not be_valid
      expect(building.errors[:street_address]).to eq(["can't be blank"])
    end

    it "validates the presence of the zip code" do
      building.update_attributes(zip_code: nil)
      expect(building).to_not be_valid
      expect(building.errors[:zip_code]).to include("can't be blank")
    end

    it "validates the format of a 9-digit zip code" do
      building.update_attributes(zip_code: "10001-1234")
      expect(building).to be_valid

      building.update_attributes(zip_code: "100011234")
      expect(building).to_not be_valid
      expect(building.errors[:zip_code]).to eq(zip_code_error)
    end

    it "validates the format of a 5-digit zip code" do
      building.update_attributes(zip_code: "10001")
      expect(building).to be_valid

      building.update_attributes(zip_code: "1000")
      expect(building).to_not be_valid
      expect(building.errors[:zip_code]).to eq(zip_code_error)
    end
  end

  describe "address uniqueness" do
    it "converts street_address to lower case before saving" do
      building.street_address = "123 New Street"
      building.save
      expect(building.reload.street_address).to eq("123 new street")
    end

    it "validates uniqueness in a case-insensitive manner" do
      building_dupe = Building.new(street_address: building.street_address.upcase,
                                   zip_code: building.zip_code)
      expect(building_dupe).to_not be_valid
      expect(building_dupe.errors[:street_address])
        .to eq(["has already been taken"])
    end

    it "permits the same street address with different zip codes" do
      building_2 = Building.new(street_address: building.street_address,
                                zip_code: "99999")
      expect(building_2).to be_valid
    end
  end
end