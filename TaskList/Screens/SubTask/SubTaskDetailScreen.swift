//
//  SubTaskDetailScreen.swift
//  TaskList
//
//  Created by 土橋正晴 on 2025/04/07.
//

import SwiftUI
import SwiftData

struct SubTaskDetailScreen: View {
    
    @Environment(\.dismiss) private var dismiss
    
    @Environment(\.modelContext) var modelContext
    
    @State private var isSetStartDate = false
    
    @State private var isSetEndDate = false
    
    @State private var isValidation = false
    @State private var validationMessage = "未入力箇所があります。"
    
    @Bindable var subTask: SubTask
        
    @State private var backConfirmAlert: Bool = false
    
    @State private var title: String = ""
    @State private var detail: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var priority: String = ""
    @State private var status: String = ""
    @State private var manHours: String = "" {
        didSet {
            manHours = "\(floor((Double(manHours) ?? 0) * 100)/100)"
        }
    }
    
    private var isDoubleManHours: Bool {
        if manHours.isEmpty {
            return true
        }
        guard let _ = Double(manHours) else {
            return false
        }
        return true
    }
    
    init(subTask: SubTask) {
        _subTask = .init(subTask)
        _title = .init(initialValue: subTask.title)
        _detail = .init(initialValue: subTask.detail)
        _detail = .init(initialValue: subTask.detail)
        _startDate = .init(initialValue: DateFormatter.format_yyyyMMddHHmm_str(subTask.startDate ?? ""))
        _endDate = .init(initialValue: DateFormatter.format_yyyyMMddHHmm_str(subTask.deadline ?? ""))
        _priority = .init(initialValue: subTask.priority)
        _status = .init(initialValue: subTask.status)
        _manHours = .init(initialValue: subTask.manHours)
    }
    
    var body: some View {
        List {
            Section(content: {
                TextField(R.string.message.inputTitle(), text: $title)
            }, header: {
                Text(R.string.label.title())
            })
            
            Section(content: {
                TextField(R.string.message.inputDetail(), text: $detail)
            }, header: {
                Text(R.string.label.detail())
            })
            
            Section(content: {
                Toggle(R.string.message.isSetStartDate(), isOn: $isSetStartDate)
                
                if isSetStartDate {
                    DatePicker(R.string.message.inputStartDate(), selection: $startDate)
                }
                
                Toggle(R.string.message.isSetDeadline(), isOn: $isSetEndDate)
                
                if isSetEndDate {
                    DatePicker(R.string.message.inputDeadline(), selection: $endDate)
                }
                
            }, header: {
                Text(R.string.label.date())
            })
            
            
            Section(content: {
                Picker(R.string.label.priority(), selection: $priority) {
                    ForEach(Prioritys.allCases) {
                        Text($0.title)
                            .tag($0)
                    }
                }
                
                Picker(R.string.label.status(), selection: $status) {
                    ForEach(TaskStatus.allCases) {
                        Text($0.title)
                            .tag($0)
                    }
                }
            })
            
            Section(content: {
                TextField("工数を入力してください", text: $manHours)
                    .keyboardType(.numbersAndPunctuation)
            }, header: {
                Text("工数")
            })
        }
        .navigationTitle("サブタスク")
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    guard subTask.hasChanges(title: title,
                                             detail: detail,
                                             startDate: DateFormatter.format_yyyyMMddHHmm(startDate),
                                             deadline: DateFormatter.format_yyyyMMddHHmm(endDate),
                                             priority: priority,
                                             status: status,
                                             manHours: manHours,
                                             isSetStartDate: isSetStartDate,
                                             isSetEndDate: isSetEndDate) else {
                        dismiss()
                        return
                    }
                    backConfirmAlert = true
                }) {
                    Image(systemName: "chevron.backward")
                }
            }
            
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    delete()
                }) {
                    Image(systemName: "trash")
                }
            }
            
        }
        .alert("変更されている箇所があります、保存して離れますか？", isPresented: $backConfirmAlert, actions: {
            saveButton
            notSavedBackButton
            Button(role: .cancel, action: {
                backConfirmAlert = false
            }, label: {
                Text("キャンセル")
            })
            
        })
        .alert(validationMessage, isPresented: $isValidation, actions: {
            Button(role: .cancel, action: {
                backConfirmAlert = false
            }, label: {
                Text(R.string.button.close())
            })
            
        })
        .task(id: subTask) {
            isSetStartDate = subTask.startDate != nil
            isSetEndDate = subTask.deadline != nil
        }
    }
    
    
    private var saveButton: some View {
        Button(role: .none, action: {
            do {
                if !isDoubleManHours {
                    validationMessage = "工数の値が不正です。"
                    isValidation = true
                    return
                }
                subTask.update(isSetStartDate: isSetStartDate, isSetEndDate: isSetEndDate,
                               title: title,
                               detail: detail,
                               startDate: startDate,
                               deadline: endDate,
                               priority: priority,
                               status: status,
                               manHours: manHours)
                try modelContext.save()
                dismiss()
            } catch {
                modelContext.rollback()
                validationMessage = "更新に失敗しました"
                isValidation = true
            }
        }, label: {
            Text("保存")
        })
    }
    
    
    private var notSavedBackButton: some View {
        Button(role: .none, action: {
            backConfirmAlert = false
            modelContext.rollback()
            dismiss()
            
        }, label: {
            Text("変更箇所を戻して、前画面に戻る")
        })
    }
    
    private func delete() {
        do {
            modelContext.delete(subTask)
            try modelContext.save()
            dismiss()
        } catch {
            modelContext.rollback()
            validationMessage = "削除に失敗しました"
            isValidation = true
        }
    }
    
}
