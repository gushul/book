class GcmJob
  @queue = :gcm

  def self.perform(device_id, message)
    require 'gcm'
		gcm = GCM.new("AIzaSyCuLrwmoxy0wOsBxYCClE7c6odAV_k3OZ8")
		registration_ids= []
		registration_ids << device_id
		options = {data: {message: message}, collapse_key: "updated_score"}
		response = gcm.send(registration_ids, options)
		p response
  end

 
end