import React, { Component } from 'react';
import UserAPI from '../api/UserAPI.js';

class TrackOrderComponent extends Component {
	constructor(props)
	{
		super(props)
		this.state = {
			orders : []
		}
		this.handleSuccessfulResponse = this.handleSuccessfulResponse.bind(this)
		this.handleErrorResponse = this.handleErrorResponse.bind(this)
	}
	
  render() {
    return (
      <div className="TrackOrderComponent">
	  <h1>TODO : Implement Track Order Component</h1>
		<center>
			<table style={tableStyle} className="table">
			<thead>
				<col width="130"/>
				<col width="180"/>
				<col width="80"/>
				<tr>
					<td>Book</td>
					<td>Status</td>
					<td>Status Date</td>
				</tr>
			</thead>
			<tbody>
				{
					this.state.orders.map(order => 
							<tr key={order.bookId}>
								<td style={tdWidth}><img width="70px" src={'data:image/jpeg;base64,' + order.image}/></td>
								<td style={tdWidth}>{order.status}</td>
								<td style={tdWidth}>{order.statusDate}</td>
							</tr>
					)
				}
			</tbody>
		</table>
		</center>
      </div>
    );
  }
  
  componentDidMount()
  {
    console.log(`GrandChild did mount. ${this.props.match.params.title}`);
	UserAPI.executeTrackOrderAPIService()
	.then(response => this.handleSuccessfulResponse(response))
	.catch(error => this.handleErrorResponse(error))
  }
  
  handleSuccessfulResponse(response)
  {
	  console.log(response)
	  console.log(response.data)

	  this.setState({
		  orders : response.data
	  })
  }
  
  handleErrorResponse(error)
  {
	  console.log(error);
	  if(error.response.status === 404)
		error.response.status = error.response.status + ' Not found';

	  var errorObj =
	  {
		  status: error.response.status,
		  details: error.response.data.details,
		  message: error.response.data.message,
		  timestamp: error.response.data.timestamp
	  }
	  this.props.history.push({
		  pathname: '/error',
		  state: errorObj
	  })
  }
}

var tableStyle = 
{
	width: '60%'
}

var tdWidth =
{
	width: '20%'
}

export default TrackOrderComponent;