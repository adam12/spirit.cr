file "spirit" => Rake::FileList["src/*.cr"] do |t|
  version = `crystal eval 'require "./src/spirit/version.cr"; puts Spirit::VERSION'`
  sh "crystal build --release src/spirit.cr -o dist/#{t.name}-#{version}"
end

task default: ["spirit"]
