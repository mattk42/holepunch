module AwsAccountsHelper

	def checkInstancePermissions(instance, user)
	    #Go through each allowed tag and verify that the user has permissions for this instance. \
	    allowed=false
	    instance_tags=instance.tags.to_h
	    if user.tags.count > 0
	      user.tags.each do |tag|
	        if instance_tags[tag.key]==tag.value
	          allowed=true
	          break
	        end
	      end
	    else
	      allowed=true
	    end

	    if !allowed
	      throw "Permission Denied"
	    end

	end



end
