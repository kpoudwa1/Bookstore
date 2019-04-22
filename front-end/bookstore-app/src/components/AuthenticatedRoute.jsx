import React, { Component } from 'react';
import {Route, Redirect} from 'react-router-dom';
import UserAPI from '../api/UserAPI.js';

class AuthenticatedRoute extends Component {
    render() {
        if (UserAPI.isUserLoggedIn())
		{
            return <Route {...this.props} />
        }
		else
		{
            return <Redirect to="/" />
        }
    }
}

export default AuthenticatedRoute;