window = @
ua = navigator.userAgent
isIe = !-[1,]
# 私有方法
unit = 
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

window.selectTxt = unit.selectTxt
