class Folder
  include DataMapper::Resource
  property :id, Serial
  property :name, String

  has n, :bookmarks, "Bookmark", child_key: "folder_id"

  validates_presence_of :name

  def as_json(with_bookmarks = true)
    json = {
      id: id,
      name: name
    }

    if with_bookmarks
      json[:bookmarks] = bookmarks.map{|b| b.as_json(false)}
    end

    json
  end
end