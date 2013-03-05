module TimeLimit
  module IssuesControllerPatch

    def self.included(base)
      base.class_eval do
        unloadable

        before_filter :time_limit_check_ip, :only => [:update]

        def start_timer
          # write logic
          redirect_to issue_path(@issue)
        end

        def stop_timer
          # write logic
          redirect_to issue_path(@issue)
        end

        private

        def time_limit_check_ip
          @issue.time_limit_allowed_ip = @allowed_ip
        end

      end
    end
  end
end
