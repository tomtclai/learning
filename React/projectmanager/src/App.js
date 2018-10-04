import React, { Component } from 'react';
import Projects from './Components/Projects';
import './App.css';
class App extends Component {

  constructor() {
    super();
    this.state = {
      projects : []
    }
  }
  
  componentWillMount(){
    this.setState({projects: [
      {
        title: 'Business website',
        category: 'Web Design'
      }, 
      {
        title: 'Social App',
        category: 'Mobile Development'
      },  
      {
        title: 'Ecommerce shopping cart',
        category: 'Web development'
      }
    ]});
  }


  render() {
    return (
      <div className="App">
        My app
        <Projects projects={this.state.projects} />
      </div>
    );
  }
}

export default App;
