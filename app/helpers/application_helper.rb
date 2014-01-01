module ApplicationHelper
	# app/helpers/application_helper.rb
	def shallow_args(parent, child)
	  child.try(:new_record?) ? [parent, child] : child
	end

	def cidr_contains(cidr,ip)
		if cidr.include?('/0')
			logger.info "Got a zero!"
			return true
		else
			cidr = NetAddr::CIDR.create(cidr)

			#cidr.contains doesn't seem to work with /32 ranges. Work around that.
			return cidr.enumerate.include?(ip)
			#cidr.contains?(ip)
		end
    end
end
