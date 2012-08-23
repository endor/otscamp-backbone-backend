class Bookmark
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :url, String

  belongs_to :folder, "Folder", required: false, child_key: "folder_id"

  validates_presence_of :name, :url

  def as_json(with_folder = true)
    json = {
      id: id,
      name: name,
      url: url
    }

    if with_folder && folder
      json[:folder] = folder.as_json(false)
    end

    json
  end
end