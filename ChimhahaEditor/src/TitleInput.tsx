interface TitleInputProps {
    value: string;
    onChange: (value: string) => void;
}

export default function TitleInput({ value, onChange }: TitleInputProps) {
    return (
        <input
        className="title-input"
        type="text"
        placeholder="제목을 입력하세요"
        value={value}
        onChange={(e) => onChange(e.target.value)}
        />
    );
}