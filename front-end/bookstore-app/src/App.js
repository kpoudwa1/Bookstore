import React, { Component } from 'react';
import IndexComponent from './components/IndexComponent';
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
