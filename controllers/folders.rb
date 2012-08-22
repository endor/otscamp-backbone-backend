App.class_eval do
  get '/folders' do
    [200, Folder.all.map(&:as_json).to_json]
  end

  get '/folders/:id' do
    folder = Folder.get(params["id"])

    if folder
      [200, folder.as_json.to_json]
    else
      not_found
    end
  end

  post '/folders' do
    clean_params

    folder = Folder.create params

    if folder.valid?
      [201, folder.as_json.to_json]
    else
      [422, folder.errors.to_hash.to_json]
    end
  end

  delete '/folders/:id' do
    folder = Folder.get(params.delete("id"))

    if folder
      folder.destroy
      status 204
    else
      not_found
    end
  end
end