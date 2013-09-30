window = @
document = window.document
ua = navigator.userAgent
isIe = !-[1,]
# 私有方法
unit = 
	extend: (destination, source) ->
		for k of source
			destination[k] = source[k]
		return destination
	on: (element, type, handler) ->
		if element.addEventListener
			element.addEventListener type, handler, false
		else
			element.attachEvent `"on" + type`, handler
		return
	selectTxt: (obj, callback) ->
		unit.on(obj, 'mouseup', (ev) ->
			ev = ev || window.event
			target = ev.target || ev.srcElement

			if /input|textarea/i.test(target.tagName) and /firefox/i.test(ua)
				# Firefox在文本框内选择文字
				staIndex = target.selectionStart
				endIndex = target.selectionEnd
				if staIndex != endIndex
					sText = target.value.substring staIndex, endIndex
					callback and callback sText, target
			else
				# 获取选中文字
				if not isIe
					sText = document.getSelection().toString()
				else 
					sText = document.selection.createRange().text
				if sText != ''
					# 将参数传入回调函数fn
					callback and callback sText, target
			return
		)
		return

Slt = (opts) ->
	@toolBarClass = opts.toolBarClass


Slt:: = 
	createMenu: ->
		icons = ''
		for name in @list
			icons += '<i class="icon-' + name + '" data-action="' + name + '">'

		menu = document.createElement 'div'
		menu.setAttribute 'class', @toolBarClass + '-menu'
		menu.innerHTML = icons;
		menu.style.display = 'none';

		document.body.appendChild menu

# 默认参数
defultConfig = 
	toolBarClass: 'slt'
	list: [
		'p'
	]

window.slt = (opts) ->
	opts = extend defultConfig, opts
	new Slt opts
