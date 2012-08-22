require "spec_helper"

describe "folders" do
  describe "get /folders" do
    it "returns 200 and all folders" do
      folder = Folder.create! name: "Satu"
      get "/folders"
      last_response.status.should eql(200)
      folder = json_response.first
      folder["name"].should eql("Satu")
      folder["id"].should_not be_nil
    end
  end
  
  describe "get /folders/:id" do
    it "returns 200 and the folder if found" do
      folder = Folder.create! name: "Satu"
      get "/folders/#{folder.id}"
      last_response.status.should eql(200)
      json_response["name"].should eql("Satu")
    end

    it "returns 404 if not found" do
      get "/folders/2"
      last_response.status.should eql(404)
    end
  end

  describe "post /folders" do
    it "creates a folder and returns it" do
      post "/folders", name: "Satu"
      last_response.status.should eql(201)
      json_response["name"].should eql("Satu")
      get "/folders/1"
      json_response["name"].should eql("Satu")
    end

    it "returns the errors if the folder couldn't be created" do
      post "/folders"
      last_response.status.should eql(422)
      json_response["name"].should eql(["Name must not be blank"])
    end    
  end
  
  describe "delete /folders/:id" do
    before(:each) do
      Folder.create! name: "Satu"
    end
    
    it "returns 204 and deletes the folder if found" do
      delete "/folders/1"
      last_response.status.should eql(204)
      Folder.all.should be_empty
    end

    it "returns 404 if folder could not be found" do
      delete "/folders/2"
      last_response.status.should eql(404)
    end
  end
end
