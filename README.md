# qfixhowmutils
## qfixhowmstylelistcount
qfixhowmの処理リスト"{ }"をカウントするやつ

vimrcのstatuslineで `[%{CountTodo()}]` こんな感じで設定しておくと、 `[0/5]` としてくれる

## 使い方
- `set statusline=[%{CountTodo()}]`
- `set statusline=[%{PercentageTodo()}]`
- `set statusline=[%{BarTodo(5)}]`
