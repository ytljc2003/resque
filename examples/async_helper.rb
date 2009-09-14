# If you want to just call a method on an object in the background,
# we can easily add that functionality to Resque.

# Here's our ActiveRecord class
class Repository < ActiveRecord::Base
  # This will be called by a worker when a job needs to be processed
  def self.perform(id, method, *args)
    find(id).send(method, *args)
  end

  # We can pass this any Repository instance method that we want to
  # run later.
  def async(method, *args)
    Resque.enqueue(Repository, method, *args)
  end
end

# Now we can call any method and have it execute later:

@repo.async(:update_disk_usage)

# or

@repo.async(:update_network_source_id, 34)
