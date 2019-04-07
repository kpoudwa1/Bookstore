import React, { Component } from 'react';
import {Link} from 'react-router-dom';
import SearchAPI from '../api/SearchAPI.js';

class SearchResultComponent extends Component {
	constructor(props)
	{
		super(props)
		this.state = {
			books : []
		}
	}
	
  render() {
    return (
      <div className="SearchResultComponent">
		<label><h2>Results...</h2></label>
		<table>
			<tbody>
				{
					this.state.books.map(book => 
							<tr>
								<td><img width="70px" src={'data:image/jpeg;base64,' + book[2]}/></td>
								<td><Link to={"/bookdetails/" + book[0]}>{book[1]}</Link></td>
							</tr>
					)
				}
			</tbody>
		</table>
      </div>
    );
  }
  
  handleLoad()
  {
	  console.log('On load')
  }
  
  componentDidMount()
  {
    console.log(`GrandChild did mount. ${this.props.match.params.title}`);
	SearchAPI.executeSearchAPIService(this.props.match.params.title)
	.then(response => this.handleSuccessfulResponse(response))
  }
  
  handleSuccessfulResponse(response)
  {
	  console.log(response.data)
	  this.setState({
		  books: response.data
	  })
	  console.log('Books:::::::::')
	  console.log(this.state.books[0][2])
	  
	  return (
		<div>Hi TEST</div>
	  )
  }
}

export default SearchResultComponent;