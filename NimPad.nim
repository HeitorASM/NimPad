import nigui
import std/os

app.init()

let window = newWindow("NimPad")
window.width = 600
window.height = 450

let container = newLayoutContainer(Layout_Vertical)
window.add(container)

let controls = newLayoutContainer(Layout_Horizontal)
container.add(controls)

let fileInfo = newLayoutContainer(Layout_Horizontal)
container.add(fileInfo)

let lblFile = newLabel("Arquivo:")
fileInfo.add(lblFile)

let fileNameInput = newTextBox()
fileNameInput.text = "sem_titulo.txt"
fileInfo.add(fileNameInput)

let textArea = newTextArea()
container.add(textArea)

let btnOpen = newButton("Abrir")
controls.add(btnOpen)

btnOpen.onClick = proc(event: ClickEvent) =
  let dialog = newOpenFileDialog()
  dialog.title = "Selecionar arquivo"
  dialog.run()
  if dialog.files.len > 0:
    try:
      textArea.text = readFile(dialog.files[0])
      fileNameInput.text = dialog.files[0]
    except IOError:
      window.alert("Erro ao ler o arquivo!")

let btnSave = newButton("Salvar")
controls.add(btnSave)

btnSave.onClick = proc(event: ClickEvent) =
  # --- MELHORIA: salva direto se já existe um arquivo associado ---
  if fileNameInput.text != "" and fileNameInput.text != "sem_titulo.txt":
    try:
      writeFile(fileNameInput.text, textArea.text)
    except IOError:
      window.alert("Erro ao salvar o arquivo!")
  else:
    let dialog = newSaveFileDialog()
    dialog.title = "Salvar arquivo como..."
    if fileNameInput.text != "":
      dialog.file = fileNameInput.text
    dialog.run()
    if dialog.file != "":
      try:
        writeFile(dialog.file, textArea.text)
        fileNameInput.text = dialog.file
      except IOError:
        window.alert("Erro ao salvar o arquivo!")

let btnNew = newButton("Novo")
controls.add(btnNew)

btnNew.onClick = proc(event: ClickEvent) =
  textArea.text = ""
  fileNameInput.text = "sem_titulo.txt"

window.show()
app.run()
