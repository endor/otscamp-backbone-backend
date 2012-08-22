class Folder
  include DataMapper::Resource
  property :id, Serial
  property :name, String

  has n, :bookmarks, "Bookmark", child_key: "folder_id"

  validates_presence_of :name

  def as_json
    {
      id: id,
      name: name
    }
  end
end