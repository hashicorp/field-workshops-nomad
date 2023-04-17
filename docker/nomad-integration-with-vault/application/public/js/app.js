/**
 * Copyright (c) HashiCorp, Inc.
 * SPDX-License-Identifier: MPL-2.0
 */

//////////////////////////////////////////////////////////////////////////////////////
//
//  file:           app.js
//  author:         Patrick Gryzan
//  date:           02/14/20
//  description:    client side js code make the single page application (spa) come to life
//
//////////////////////////////////////////////////////////////////////////////////////

//  view model
function viewModel() {
    var self = this;
    
    self.members = ko.observableArray([]);
    self.url = '/api';

    self.list = function() {
        $.ajax({
            url: self.url,
            type: 'GET',
            success: function(result) {
                self.members(result);
            }
        });
    };

    self.list();
};

//  doument has been loaded and ready bind the view model
$(document).ready(function() {
    ko.applyBindings(new viewModel());
});