StaffPenthousePropertyUseCase = {}

function StaffPenthousePropertyUseCase.Create(data)
    StaffPenthouseRepository.Save(data)
    return { success = true }
end
