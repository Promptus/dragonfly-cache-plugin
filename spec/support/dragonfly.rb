Dragonfly.app.configure do

  url_format "/media/:job/:name"

  datastore :file,
    root_path: File.join(test_server_root, 'static-cache'),
    server_root: test_server_root

  secret 'f8f295fb4b7a773fcd228c51ef46d609'
end
