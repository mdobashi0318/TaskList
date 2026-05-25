//
//  AddTaskScreen.swift
//  TaskList
//
//  Created by 土橋正晴 on 2025/03/23.
//

import SwiftUI
import SwiftData

struct AddTaskScreen: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var modelContext
    var model: TaskModel?
    @State private var title: String = ""
    @State private var detail: String = ""
    @State private var isSetStartDate = false
    @State private var startDate: Date = Date()
    @State private var isSetEndDate = false
    @State private var endDate: Date = Date()
    @State private var priority: Prioritys = .none
    @State private var isValidation = false
    @State private var validationMessage = R.string.message.notYetEntered()
    @State private var isDetail = false
    @State private var tag: Tag?
    @State private var tagSelect = false
    
    @AppStorage(UserDefaults.Key.addFirstTask.rawValue) private var addFirstTask: Bool = false
    
    var body: some View {
        NavigationStack {
            List {
                Section(content: {
                    TextField(R.string.message.inputTitle(), text: $title)
                    TextField(R.string.message.inputDetail(), text: $detail, axis: .vertical)
                }, header: {
                    Text("NewTask")
                })
                
                Section(content: {
                    if isDetail {
                        Toggle(R.string.message.isSetStartDate(), isOn: $isSetStartDate)
                        
                        if isSetStartDate {
                            DatePicker(R.string.message.inputStartDate(), selection: $startDate)
                        }
                        
                        Toggle(R.string.message.isSetDeadline(), isOn: $isSetEndDate)
                        
                        if isSetEndDate {
                            DatePicker(R.string.message.inputDeadline(), selection: $endDate)
                        }
                    }
                }, header: {
                    HStack {
                        Text(R.string.label.detail())
                        Spacer()
                        IconButton(action: {
                            isDetail.toggle()
                        }, iconName: isDetail ? .chevronDown : .chevronUp)
                        .foregroundStyle(Color(uiColor: .secondaryLabel))
                    }
                })
                
                
                if isDetail {
                    Section(content: {
                        Picker(R.string.label.priority(), selection: $priority) {
                            ForEach(Prioritys.allCases) {
                                Text($0.title)
                                    .tag($0)
                            }
                        }
                        HStack {
                            Button("tag") {
                                tagSelect.toggle()
                            }
                            .foregroundStyle(Color.textColor)
                            Spacer()
                            if let tag {
                                ColorCircleView(color: tag.color())
                            }
                            Text(tag?.name ?? "")
                        }
                        
                    })
                }
                
            }
            .navigationTitle(R.string.screenTitle.addTaskScreen())
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    CloseButton(action: {
                        dismiss()
                    })
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    AddButton(action: {
                        addTask()
                    })
                }
            }
            .alert(validationMessage, isPresented: $isValidation, actions: {
                Button(role: .cancel, action: {
                    isValidation.toggle()
                }, label: {
                    Text(R.string.button.close())
                })
            })
            .sheet(isPresented: $tagSelect) {
                SelectTagScreen(tag: $tag)
            }
        }
    }
    
    
    private func addTask() {
        if title.isEmpty {
            validationMessage = R.string.message.inputTitle()
            isValidation = true
            return
        }
        
        do {
            let taskModel = TaskModel()
            taskModel.add(title: title,
                          detail: detail,
                          startDate: isSetStartDate ? DateFormatter.format_yyyyMMddHHmm(startDate) : nil,
                          deadline: isSetEndDate ? DateFormatter.format_yyyyMMddHHmm(endDate) : nil,
                          priority: priority.rawValue,
                          tag: tag)
            
            modelContext.insert(taskModel)
            try modelContext.save()
            
            if !addFirstTask {
                addFirstTask = true
            }
            dismiss()
        } catch {
            validationMessage = R.string.message.addError()
            isValidation = true
        }
        
        
    }
}
