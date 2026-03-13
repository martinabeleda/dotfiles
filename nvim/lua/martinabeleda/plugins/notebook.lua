local setup, notebook = pcall(require, "notebook")
if not setup then
	return
end

notebook.setup()
