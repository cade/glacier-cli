# Glacier::CLI

Basic CLI for AWS Glacier to back up files.

## Installation

Install it:

    $ gem install glacier-cli

## Usage

Prerequisites:

You'll need to set the following three things in environment variables:

    ENV['AWS_REGION']
    ENV['AWS_ACCESS_KEY']
    ENV['AWS_SECRET_ACCESS_KEY']

Basic usage:

    $ glacier -v my_vault -d path/to/files

- You must provide the name of a vault that already exists on Glacier. You can [create a new vault via the AWS web console](http://docs.aws.amazon.com/amazonglacier/latest/dev/getting-started-create-vault.html).
- You must specify at least one file or directory to upload.
- **Note:** using the `-d` option will recursively store everything in that directory.
- `glacier` ignores dotfiles (ex. `.gitignore`) and the contents of hidden directories (ex. `.git`)

Advanced usage:

    $ glacier -h
    glacier [options]
        -v, --vault VAULT_NAME           Name of vault to store archives in
        -f, --file [FILE_NAME]           Path of file to store
        -d, --directory [DIRECTORY_NAME] Path of directory to recursively store
        -h, --help                       Show help
            --version                    Show version

You can provide the path to individual files with the `-f` option. You can specify multiple files or directories like so:

    $ cd ~/my_movies
    $ glacier -v my_vault -d holiday_movies -d kids_movies -f foo.mp4 -f bar.mp4

## Duplicate Handling

There is currently a very naive system for avoiding uploading the same files to Glacier (say, due to a restart after network interruption). `glacier` writes the base names of the files it uploads successfully to `~/.glacier`. So if you have two files with the same name in two different directories and you want to use this, you'll need to make unique file names until I have some cause to make it better.

## Contributing

1. Fork it ( https://github.com/cade/glacier-cli/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
