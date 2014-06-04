# lita-bitbucket-pullrequest

lita-bitbucket-pullrequest is a handler for [Lita](https://github.com/jimmycuadra/lita) that aimed at receiving pull request messages from [Bitbucket](hhttps://bitbucket.org).

## Installation

Add lita-bitbucket-pullrequest to your Lita instance's Gemfile:

``` ruby
gem "lita-bitbucket-pullrequest"
```


## Usage

You will need to add a BitBucket Pull Request Post hook that points to: `http://example.com/bitbucket_pullrequest?room=xxxxxx`

`room` - The plugin sends messages in this room.

## License

[MIT](http://opensource.org/licenses/MIT)
