import React, { Component } from 'react';
import IndexComponent from './components/IndexComponent';
import LoginComponent from './components/LoginComponent';
import logo from './logo.svg';
import './App.css';
import './bootstrap.css';

class App extends Component {
  render() {
    return (
      <div className="App">
	  <IndexComponent/>
	  {/*<LoginComponent/>*/}
      </div>
    );
  }
}

export default App;
