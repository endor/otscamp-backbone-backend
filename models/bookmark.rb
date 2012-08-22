class Bookmark
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :url, String

  belongs_to :folder, "Folder", required: false, child_key: "folder_id"

  validates_presence_of :name, :url

  def as_json
    {
      id: id,
      name: name,
      url: url,
      folder: folder
    }
  end
end