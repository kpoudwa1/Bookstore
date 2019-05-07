import React, { Component } from 'react';
import Logo from '../logo-white.png';

class AboutComponent extends Component {
  render() {
    return (
      <div className="LoginComponent">
		<div><a href="/" className="navbar-brand"><img alt="Turn the page" src={Logo} width="150" height="150"/></a></div>
		<p>This is a project carried out under the supervision of a member of the Computer Science Department. Further information is available in the department office. Prerequisites: consent of instructor and committee members.</p>
		<p>Turn the page is a online book store.</p>
      </div>
    );
  }
}

export default AboutComponent;