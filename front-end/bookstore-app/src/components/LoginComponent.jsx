import React, { Component } from 'react';

class LoginComponent extends Component {
  render() {
    return (
      <div className="LoginComponent">
		Logo
		<center>
			<table frame="box">
				<tr>
					<td>Email</td>
					<td><input type="text" name="email"/></td>
				</tr>
				<tr>
					<td>Password</td>
					<td><input type="password" name="password"/></td>
				</tr>
				<tr>
					<td></td>
					<td><input type="submit" value="Log In" /></td>
				</tr>
				<tr>
					<td>New user</td>
					<td><input type="submit" value="Create a new account" /></td>
				</tr>
			</table>
		</center>
      </div>
    );
  }
}

export default LoginComponent;