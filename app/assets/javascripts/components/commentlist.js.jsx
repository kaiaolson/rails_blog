var CommentList = React.createClass({
  getInitialState: function(){
    return {comments: this.props.comments, postId: this.props.post_id};
  },
  componentDidMount: function(){
    setInterval(function(){
      $.ajax({
        url: "http://localhost:3000/posts/" + this.state.postId + "/comments.json",
        method: "GET",
        failure: function(){
          alert("failed");
        },
        success: function(data){
          this.setState({comments: data.comments})
        }.bind(this)
      })
    }.bind(this), 10000);
  },
  commentsDisplay: function(){
    if(this.state.comments.length > 0) {
      return this.state.comments.map(function(comment, index){
        return <Comment id={comment.id} body={comment.body} createdAt={comment.created_at} key={index} />
      });
    }
  },
  render: function(){
    return <div>
            {this.commentsDisplay()}
           </div>;
  }
});

var Comment = React.createClass({
  render: function(){
    var edit_url = "/comments/" + this.props.id + "/edit";
    var delete_url = "/comments/" + this.props.id + "?_method=delete";
    var comment_id = "comment_" + this.props.id;
    return <div id={comment_id}>{this.props.body} |  {this.props.createdAt} <a href={edit_url} data-remote="true" className="btn btn-warning">Edit</a> <a href={delete_url} data-remote="true" className="btn btn-danger">Delete</a><hr></hr></div>;
  }
});
