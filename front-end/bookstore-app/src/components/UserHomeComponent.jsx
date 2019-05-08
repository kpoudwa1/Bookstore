import React, { Component } from 'react';
import UserAPI from '../api/UserAPI.js';

class UserHomeComponent extends Component {
	
  render() {
    return (
      <div className="UserHomeComponent">
		<h1>Welcome {UserAPI.getUserName()}</h1>
      </div>
    );
  }
}

export default UserHomeComponent;