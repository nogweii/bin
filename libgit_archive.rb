# Ruby library functions for the profile archive suite.
require 'open-uri'
require 'grit'

Archive_Directory = File.join(ENV['HOME'], 'archives')

# Make sure that grit isn't confused as to where the git binary is.
Grit::Git.git_binary = "/usr/bin/git"
# cd to the archives directory, where the git repo is.
Dir.chdir Archive_Directory

@repo = Grit::Repo.new('.')

# Given a URL and a path, download whatever the URL has and stick it into the
# file.
#
# Afterwards, add the file to the git commit.
def download(url, file)
    # First, open the remote file. (FD == 'File Descriptor', a C term)
    #
    # If we first open the remote file, if there are any exceptions in
    # attempting to open it, we won't lose the contents of the local file.
    open(url) do |remoteFD|
        # Open the local file, purging the contents.
        File.open(file, "w") do |genericFD|
            remoteFD.each_line do |line|
                # Take each line, stick it in the file.
                genericFD.puts line
            end
        end
    end
    @repo.add(file) # add the file to the list to be committed
end

# Given a commit message, prepend 'Cron Job' and commit the changes.
def commit(message)
    @repo.commit_index("Cron Job: #{message}") # Commit.
end
