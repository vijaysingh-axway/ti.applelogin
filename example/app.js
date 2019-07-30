var AppleLogin = require('ti.applelogin');
var userId = '';

var win = Ti.UI.createWindow({
    backgroundColor: '#fff'
});

var signInButton = AppleLogin.createSignInButton({
    type: AppleLogin.BUTTON_TYPE_SIGNIN,
    style: AppleLogin.BUTTON_STYLE_BLACK,
    top: 150,
    height: 50,
    width: 300,
    cornerRadius: 10
});


signInButton.addEventListener('click', function () {
    AppleLogin.login({
        authorizationScopes: [AppleLogin.AUTHORIZATION_SCOPE_EMAIL, AppleLogin.AUTHORIZATION_SCOPE_FULLNAME],
        callback: function(e) {
            if (e.success === true) {
                Ti.API.info(e.user);
                userId = e.user;
               Ti.API.info('Login successfully');
               alert('Login successfully');
            } else {
               Ti.API.info('Login failed');
               alert('Login failed');
            }
        }
    });
});


var btn = Ti.UI.createButton({
    top: 250,
    title: 'Get Credential State'
});

btn.addEventListener('click', function () {
        Ti.API.info(userId);
    if (userId === '') {
        alert('Please login first');
        return;
    }
    AppleLogin.credentialState({
        userId: userId,
        callback: function(e) {
            Ti.API.info(e.credentialState);
            Ti.API.info(e.error);
        }
    });
});

win.add(signInButton);
win.add(btn);
win.open();
