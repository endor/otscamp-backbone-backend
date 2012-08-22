App.class_eval do
  get '/bookmarks' do
    [200, Bookmark.all.map(&:as_json).to_json]
  end

  get '/bookmarks/:id' do
    bookmark = Bookmark.get(params["id"])

    if bookmark
      [200, bookmark.as_json.to_json]
    else
      not_found
    end
  end

  put '/bookmarks/:id' do
    clean_params

    if params["folder"]
      folder = Folder.get(params["folder"]["id"])

      if folder
        params["folder"] = folder
      else
        return [422, {"folder" => "could not be found"}.to_json]
      end
    end

    bookmark = Bookmark.get(params.delete("id"))

    if bookmark
      bookmark.update params

      if bookmark.valid?
        [200, bookmark.as_json.to_json]
      else
        [422, bookmark.errors.to_hash.to_json]
      end
    else
      not_found
    end
  end

  post '/bookmarks' do
    clean_params

    if params["folder"]
      folder = Folder.get(params["folder"]["id"])

      if folder
        params["folder"] = folder
      else
        return [422, {"folder" => "could not be found"}.to_json]
      end
    end

    bookmark = Bookmark.create params

    if bookmark.valid?
      [201, bookmark.as_json.to_json]
    else
      [422, bookmark.errors.to_hash.to_json]
    end
  end

  delete '/bookmarks/:id' do
    bookmark = Bookmark.get(params.delete("id"))

    if bookmark
      bookmark.destroy
      status 204
    else
      not_found
    end
  end
end