require "spec_helper"

describe "bookmarks" do
  describe "get /bookmarks" do
    it "returns 200 and all bookmarks" do
      bookmark = Bookmark.create! name: "Muumimaailma", url: "http://www.muumimaailma.fi/"
      get "/bookmarks"
      last_response.status.should eql(200)
      bookmark = json_response.first
      bookmark["name"].should eql("Muumimaailma")
      bookmark["url"].should eql("http://www.muumimaailma.fi/")
      bookmark["id"].should_not be_nil
      bookmark["folder"].should be_nil
    end
  end
  
  describe "get /bookmarks/:id" do
    it "returns 200 and the bookmark if found" do
      bookmark = Bookmark.create! name: "Muumimaailma", url: "http://www.muumimaailma.fi/"
      get "/bookmarks/#{bookmark.id}"
      last_response.status.should eql(200)
      json_response["name"].should eql("Muumimaailma")
    end

    it "returns 404 if not found" do
      get "/bookmarks/2"
      last_response.status.should eql(404)
    end
  end

  describe "post /bookmarks" do
    it "creates a bookmark and returns it" do
      post "/bookmarks", {name: "Muumimaailma", url: "http://www.muumimaailma.fi/"}.to_json
      last_response.status.should eql(201)
      json_response["name"].should eql("Muumimaailma")
      get "/bookmarks/1"
      json_response["name"].should eql("Muumimaailma")
    end

    it "returns the errors if the bookmark couldn't be created" do
      post "/bookmarks"
      last_response.status.should eql(422)
      json_response["name"].should eql(["Name must not be blank"])
      json_response["url"].should eql(["Url must not be blank"])
    end
    
    it "creates bookmarks with folders" do
      Folder.create! name: "Satu"
      post "/bookmarks", {name: "Muumimaailma", url: "http://www.muumimaailma.fi/", folder: {id: 1}}.to_json
      last_response.status.should eql(201)
      get "/bookmarks/1"
      json_response["name"].should eql("Muumimaailma")
      json_response["folder"].should eql({"id" => 1, "name" => "Satu"})
    end

    it "returns an error if the folder could not be found" do
      post "/bookmarks", {name: "Muumimaailma", url: "http://www.muumimaailma.fi/", folder: {id: 1}}.to_json
      json_response["folder"].should eql("could not be found")
      last_response.status.should eql(422)
    end
  end
  
  describe "put /bookmarks/:id" do
    before(:each) do
      Bookmark.create! name: "Muumimaailma", url: "http://www.muumimaailma.fi/"
    end

    it "updates a bookmark and returns it" do
      put "/bookmarks/1", {name: "Muumit"}.to_json
      last_response.status.should eql(200)
      json_response["name"].should eql("Muumit")
      get "/bookmarks/1"
      json_response["name"].should eql("Muumit")
    end

    it "returns 404 if the bookmark could not be found" do
      put "/bookmarks/2", {name: "Muumit"}.to_json
      last_response.status.should eql(404)
    end

    it "returns the errors if the bookmark couldn't be updared" do
      put "/bookmarks/1", {name: ""}.to_json
      last_response.status.should eql(422)
      json_response["name"].should eql(["Name must not be blank"])
      get "/bookmarks/1"
      json_response["name"].should eql("Muumimaailma")
    end

    it "updates bookmarks with folders" do
      Folder.create! name: "Satu"
      put "/bookmarks/1", {name: "Muumit", folder: {id: 1}}.to_json
      last_response.status.should eql(200)
      get "/bookmarks/1"
      json_response["name"].should eql("Muumit")
      json_response["folder"].should eql({"id" => 1, "name" => "Satu"})
    end

    it "returns an error if the folder could not be found" do
      put "/bookmarks/1", {name: "Muumit", folder: {id: 1}}.to_json
      json_response["folder"].should eql("could not be found")
      last_response.status.should eql(422)
    end
  end

  describe "delete /bookmarks/:id" do
    before(:each) do
      Bookmark.create! name: "Muumimaailma", url: "http://www.muumimaailma.fi/"
    end
    
    it "returns 204 and deletes the bookmark if found" do
      delete "/bookmarks/1"
      last_response.status.should eql(204)
      Bookmark.all.should be_empty
    end

    it "returns 404 if bookmark could not be found" do
      delete "/bookmarks/2"
      last_response.status.should eql(404)
    end
  end
end
