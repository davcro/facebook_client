module FacebookClient
  require 'digest'

  class LegacySession

    def self.create_and_secure(fb, params)
      legacy_session = new(fb, params)

      legacy_session.secure? ? legacy_session : nil
    end

    def initialize(fb, params)
      @fb=fb
      @params=verfiy_params_and_return(params)
    end

    def secure?
      @params.is_a?(Hash) and @params.has_key?('user')
    end

    def uid
      @params['user']
    end

    def verfiy_params_and_return(params)
      if params['fb_sig'].nil? or !params['fb_sig'].is_a?(String)
        log 'missing fb_sig'
        return nil
      end

      facebook_sig_params = params.inject({}) do |collection, pair|
        collection[pair.first.sub(/^fb_sig_/, '')] = pair.last if pair.first[0,7] == 'fb_sig_'
        collection
      end

      if params['fb_sig']==calculate_sig(facebook_sig_params)
        log "secured for #{facebook_sig_params['user']}"
        return facebook_sig_params
      else
        log "sig #{params['fb_sig']} invalid, should be #{calculate_sig(facebook_sig_params)}"
        return nil
      end
    end

    def calculate_sig(facebook_sig_params)
      raw_string = facebook_sig_params.map{ |*args| args.join('=') }.sort.join
      Digest::MD5.hexdigest([raw_string, @fb.secret].join)
    end

    def log(msg)
      # puts("legacy_session/#{@fb.app_id} #{msg}")
    end

  end
end