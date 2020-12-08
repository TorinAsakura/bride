var SocialButtonSelector = function(selectorClass){
    this.selector = $(selectorClass)[0];
};

var SocialObjectLink = function(initParams){
    if(initParams.authUrl.match(/vkontakte/)){
       this.selector = $("a[data-link*='vkontakte_media']");
    }else if(initParams.authUrl.match(/instagram/)){
       this.selector = $("a[data-link*='instagram_media']");
    }

    this.authUrl = initParams.authUrl;
    this.validationUrl = initParams.validationUrl;
    this.tokenValid = false;
};

var SocialAuthorizer = function(){
    this.socialButtons = new SocialButtonSelector(".socials").selector;

    this.links = [];
    this.links.push(new SocialObjectLink({authUrl: "/auth/vkontakte", validationUrl: "/vkontakte_media/validate_session.json"}));
    this.links.push(new SocialObjectLink({authUrl: "/auth/instagram", validationUrl: "/instagram_media/validate_session.json"}));

    this.validateToken = function(){
        var self = this;
        $.each(this.links, function(index, link){
            $.get(link.validationUrl,
                {
                    current_user_id: link.selector.data('current-user-id')
                },
                function(authExist){
                    link.tokenValid = authExist.valid;
                    self.authorize(link);
                }
            );
        });
    };

    this.authorize = function(link){
        if(link.tokenValid){
            this.startWorkWithSocialServices(link);
        }else{
            this.createPopupForSocialAuth(link);
        }
    };

    this.createPopupForSocialAuth = function(link){
        var self = this;
        $(link.selector).on("click", function(){
            var popup = window.open(link.authUrl, "", "width=600, height=400, scrollbars=yes");
            setTimeout(function(){
                popup.close();
                self.startWorkWithSocialServices(link);
                self.clickOnSocialServiceLink(link);
            }, 20000);

        });
    };

    this.startWorkWithSocialServices = function(link){
        link.selector[0].href = link.selector.data('link');
        $(link.selector).unbind("click");
    };

    this.clickOnSocialServiceLink = function(link){
        $(link.selector).trigger('click');
    };
};
