# NativeWind Component Generator

**Category:** Mobile Development
**Priority:** High
**Dependencies:** React Native, Expo, NativeWind, Tailwind CSS

---

## Purpose

Generate React Native components styled with NativeWind (Tailwind CSS) for cross-platform mobile applications. This skill enables rapid component creation with utility-first styling that works consistently across iOS, Android, and Web platforms.

---

## When to Use

Use this skill when:
- Creating new React Native components
- Converting Figma designs to code (Phase 3)
- Building responsive Phone/Tablet variants
- Implementing consistent styling across platforms
- Need rapid prototyping with utility classes

---

## Inputs

### Required
- **Component Name:** PascalCase name (e.g., `UserProfile`, `ProductCard`)
- **Component Type:** Screen, Component, Modal, Form, etc.
- **Platform Variants:** Phone, Tablet, or Both

### Optional
- **Design Reference:** Figma screenshot or MCP data
- **Design Tokens:** Colors, spacing, typography from design system
- **Props Interface:** TypeScript props definition
- **State Requirements:** Local state, navigation, API calls

---

## Outputs

### File Structure
```
components/
├── UserProfile/
│   ├── UserProfile.tsx              # Main component (shared logic)
│   ├── UserProfile.phone.tsx        # Phone-specific layout
│   ├── UserProfile.tablet.tsx       # Tablet-specific layout
│   ├── UserProfile.styles.ts        # Complex styles if needed
│   └── index.ts                     # Barrel export
```

### Generated Files
1. **Main Component:** TypeScript component with NativeWind classes
2. **Platform Variants:** Responsive layouts using Tailwind utilities
3. **Type Definitions:** Props and state interfaces
4. **Index Export:** Clean import path

---

## NativeWind Best Practices

### 1. Utility-First Styling
```tsx
// ✅ Preferred: NativeWind utility classes
<View className="flex-1 bg-white p-4 rounded-lg shadow-md">
  <Text className="text-xl font-bold text-gray-900">Hello</Text>
</View>

// ❌ Avoid: Manual StyleSheet (unless complex calculations needed)
<View style={styles.container}>
  <Text style={styles.title}>Hello</Text>
</View>
```

### 2. Responsive Design
```tsx
// Phone vs Tablet using conditional rendering
<View className={`p-4 ${isTablet ? 'flex-row' : 'flex-col'}`}>
  <Text className={`${isTablet ? 'text-2xl' : 'text-lg'}`}>
    Responsive Text
  </Text>
</View>
```

### 3. Theme Integration
```tsx
// Use Tailwind config colors
// tailwind.config.js defines: colors.primary[500]
<TouchableOpacity className="bg-primary-500 px-6 py-3 rounded-full">
  <Text className="text-white font-semibold">Submit</Text>
</TouchableOpacity>
```

### 4. Custom Modifiers
```tsx
// Active, disabled, pressed states
<Pressable
  className={({ pressed }) =>
    `p-4 rounded-lg ${pressed ? 'bg-gray-200' : 'bg-white'}`
  }
>
  <Text>Pressable</Text>
</Pressable>
```

### 5. Dark Mode Support
```tsx
// Auto dark mode with dark: modifier
<View className="bg-white dark:bg-gray-900">
  <Text className="text-gray-900 dark:text-white">
    Dark Mode Ready
  </Text>
</View>
```

---

## Component Templates

### Template 1: Screen Component

```tsx
// UserProfile.phone.tsx
import React from 'react';
import { View, Text, ScrollView, Image, TouchableOpacity } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';

interface UserProfileProps {
  userId: string;
  onEdit?: () => void;
}

export const UserProfilePhone: React.FC<UserProfileProps> = ({
  userId,
  onEdit
}) => {
  return (
    <SafeAreaView className="flex-1 bg-gray-50">
      <ScrollView className="flex-1">
        {/* Header */}
        <View className="bg-white px-4 py-6 border-b border-gray-200">
          <View className="items-center">
            <Image
              source={{ uri: 'https://via.placeholder.com/150' }}
              className="w-24 h-24 rounded-full"
            />
            <Text className="text-2xl font-bold text-gray-900 mt-4">
              John Doe
            </Text>
            <Text className="text-base text-gray-500 mt-1">
              john.doe@example.com
            </Text>
          </View>
        </View>

        {/* Content */}
        <View className="p-4">
          <View className="bg-white rounded-lg p-4 mb-4 shadow-sm">
            <Text className="text-lg font-semibold text-gray-900 mb-2">
              About
            </Text>
            <Text className="text-base text-gray-700 leading-6">
              Software developer passionate about mobile applications.
            </Text>
          </View>

          {/* Action Button */}
          <TouchableOpacity
            onPress={onEdit}
            className="bg-blue-500 px-6 py-4 rounded-lg shadow-md active:bg-blue-600"
          >
            <Text className="text-white text-center font-semibold text-base">
              Edit Profile
            </Text>
          </TouchableOpacity>
        </View>
      </ScrollView>
    </SafeAreaView>
  );
};
```

### Template 2: Reusable Component

```tsx
// ProductCard.tsx
import React from 'react';
import { View, Text, Image, TouchableOpacity } from 'react-native';

interface ProductCardProps {
  title: string;
  price: number;
  imageUrl: string;
  onPress?: () => void;
  featured?: boolean;
}

export const ProductCard: React.FC<ProductCardProps> = ({
  title,
  price,
  imageUrl,
  onPress,
  featured = false
}) => {
  return (
    <TouchableOpacity
      onPress={onPress}
      className={`bg-white rounded-xl shadow-lg overflow-hidden ${
        featured ? 'border-2 border-yellow-400' : ''
      }`}
    >
      <Image
        source={{ uri: imageUrl }}
        className="w-full h-48"
        resizeMode="cover"
      />
      <View className="p-4">
        <Text className="text-lg font-bold text-gray-900 mb-2" numberOfLines={2}>
          {title}
        </Text>
        <View className="flex-row justify-between items-center">
          <Text className="text-xl font-bold text-blue-600">
            ${price.toFixed(2)}
          </Text>
          {featured && (
            <View className="bg-yellow-400 px-3 py-1 rounded-full">
              <Text className="text-xs font-semibold text-gray-900">
                Featured
              </Text>
            </View>
          )}
        </View>
      </View>
    </TouchableOpacity>
  );
};
```

### Template 3: Form Component

```tsx
// LoginForm.tsx
import React, { useState } from 'react';
import { View, Text, TextInput, TouchableOpacity, ActivityIndicator } from 'react-native';

interface LoginFormProps {
  onSubmit: (email: string, password: string) => Promise<void>;
}

export const LoginForm: React.FC<LoginFormProps> = ({ onSubmit }) => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');

  const handleSubmit = async () => {
    setLoading(true);
    setError('');
    try {
      await onSubmit(email, password);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Login failed');
    } finally {
      setLoading(false);
    }
  };

  return (
    <View className="bg-white rounded-2xl p-6 shadow-xl">
      <Text className="text-2xl font-bold text-gray-900 mb-6">
        Welcome Back
      </Text>

      {/* Email Input */}
      <View className="mb-4">
        <Text className="text-sm font-medium text-gray-700 mb-2">
          Email
        </Text>
        <TextInput
          value={email}
          onChangeText={setEmail}
          placeholder="your@email.com"
          keyboardType="email-address"
          autoCapitalize="none"
          className="bg-gray-50 border border-gray-300 rounded-lg px-4 py-3 text-base text-gray-900"
        />
      </View>

      {/* Password Input */}
      <View className="mb-4">
        <Text className="text-sm font-medium text-gray-700 mb-2">
          Password
        </Text>
        <TextInput
          value={password}
          onChangeText={setPassword}
          placeholder="••••••••"
          secureTextEntry
          className="bg-gray-50 border border-gray-300 rounded-lg px-4 py-3 text-base text-gray-900"
        />
      </View>

      {/* Error Message */}
      {error ? (
        <View className="bg-red-50 border border-red-200 rounded-lg p-3 mb-4">
          <Text className="text-red-700 text-sm">{error}</Text>
        </View>
      ) : null}

      {/* Submit Button */}
      <TouchableOpacity
        onPress={handleSubmit}
        disabled={loading || !email || !password}
        className={`py-4 rounded-lg ${
          loading || !email || !password
            ? 'bg-gray-300'
            : 'bg-blue-500 active:bg-blue-600'
        }`}
      >
        {loading ? (
          <ActivityIndicator color="white" />
        ) : (
          <Text className="text-white text-center font-semibold text-base">
            Sign In
          </Text>
        )}
      </TouchableOpacity>
    </View>
  );
};
```

---

## Tailwind Config Setup

### tailwind.config.js
```js
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./App.{js,jsx,ts,tsx}",
    "./src/**/*.{js,jsx,ts,tsx}",
    "./components/**/*.{js,jsx,ts,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        primary: {
          50: '#f0f9ff',
          100: '#e0f2fe',
          200: '#bae6fd',
          300: '#7dd3fc',
          400: '#38bdf8',
          500: '#0ea5e9', // Main brand color
          600: '#0284c7',
          700: '#0369a1',
          800: '#075985',
          900: '#0c4a6e',
        },
        secondary: {
          500: '#8b5cf6',
        },
        success: {
          500: '#10b981',
        },
        warning: {
          500: '#f59e0b',
        },
        error: {
          500: '#ef4444',
        },
      },
      fontFamily: {
        sans: ['Inter', 'system-ui', 'sans-serif'],
        mono: ['JetBrains Mono', 'monospace'],
      },
      spacing: {
        '128': '32rem',
        '144': '36rem',
      },
    },
  },
  plugins: [],
};
```

---

## Integration with Phase 3 (Design Review)

When processing Figma designs in Phase 3:

1. **Extract Design Tokens** → Map to Tailwind config
2. **Identify Components** → Generate with NativeWind classes
3. **Create Variants** → Phone/Tablet using responsive utilities
4. **Apply Theme** → Use custom colors from `tailwind.config.js`

### Example Workflow:
```
Figma Design (Button component)
  ↓
Extract:
  - Color: #0ea5e9 → bg-primary-500
  - Padding: 16px → p-4
  - Border Radius: 8px → rounded-lg
  ↓
Generate:
<TouchableOpacity className="bg-primary-500 px-6 py-4 rounded-lg">
  <Text className="text-white font-semibold">Submit</Text>
</TouchableOpacity>
```

---

## Common Patterns

### 1. List Items
```tsx
<View className="bg-white border-b border-gray-200 p-4">
  <Text className="text-base font-semibold text-gray-900">Item Title</Text>
  <Text className="text-sm text-gray-500 mt-1">Subtitle</Text>
</View>
```

### 2. Cards with Shadow
```tsx
<View className="bg-white rounded-xl shadow-lg p-6 mb-4">
  {/* Card content */}
</View>
```

### 3. Input Fields
```tsx
<TextInput
  className="bg-gray-50 border border-gray-300 rounded-lg px-4 py-3 text-gray-900"
  placeholderTextColor="#9ca3af"
/>
```

### 4. Badges
```tsx
<View className="bg-blue-100 px-3 py-1 rounded-full">
  <Text className="text-blue-800 text-xs font-medium">New</Text>
</View>
```

### 5. Flex Layouts
```tsx
{/* Row with space between */}
<View className="flex-row justify-between items-center">
  <Text>Left</Text>
  <Text>Right</Text>
</View>

{/* Column with gap */}
<View className="flex-col gap-4">
  <Text>Item 1</Text>
  <Text>Item 2</Text>
</View>
```

---

## Error Handling

### Common Issues:

**Issue:** NativeWind classes not applying
**Solution:**
```bash
# Rebuild Tailwind cache
npx tailwindcss --config tailwind.config.js --input input.css --output output.css
```

**Issue:** Custom colors not recognized
**Solution:** Ensure `tailwind.config.js` is properly configured and restart Metro bundler

**Issue:** Platform-specific styling needed
**Solution:** Use conditional rendering or StyleSheet for complex platform differences

---

## Testing Generated Components

```tsx
// UserProfile.test.tsx
import React from 'react';
import { render, fireEvent } from '@testing-library/react-native';
import { UserProfilePhone } from './UserProfile.phone';

describe('UserProfilePhone', () => {
  it('renders user information correctly', () => {
    const { getByText } = render(
      <UserProfilePhone userId="123" />
    );

    expect(getByText('John Doe')).toBeTruthy();
    expect(getByText('john.doe@example.com')).toBeTruthy();
  });

  it('calls onEdit when edit button pressed', () => {
    const onEdit = jest.fn();
    const { getByText } = render(
      <UserProfilePhone userId="123" onEdit={onEdit} />
    );

    fireEvent.press(getByText('Edit Profile'));
    expect(onEdit).toHaveBeenCalledTimes(1);
  });
});
```

---

## Quick Reference

| Task | NativeWind Class | StyleSheet Equivalent |
|------|------------------|----------------------|
| Flex container | `flex-1` | `{ flex: 1 }` |
| Padding 16px | `p-4` | `{ padding: 16 }` |
| Margin top 8px | `mt-2` | `{ marginTop: 8 }` |
| Background white | `bg-white` | `{ backgroundColor: '#fff' }` |
| Text size 16px | `text-base` | `{ fontSize: 16 }` |
| Font bold | `font-bold` | `{ fontWeight: 'bold' }` |
| Center items | `items-center` | `{ alignItems: 'center' }` |
| Border radius 8px | `rounded-lg` | `{ borderRadius: 8 }` |
| Shadow | `shadow-md` | Platform-specific shadow props |
| Absolute position | `absolute` | `{ position: 'absolute' }` |

---

## Success Criteria

A well-generated NativeWind component should:
- ✅ Use utility classes for 90%+ of styling
- ✅ Be responsive across Phone/Tablet
- ✅ Follow project theme colors
- ✅ Have TypeScript types for all props
- ✅ Include proper accessibility labels
- ✅ Have minimal or no StyleSheet usage
- ✅ Be tested with unit tests
- ✅ Follow naming conventions from project context

---

## References

- **NativeWind Docs:** https://www.nativewind.dev/docs
- **Tailwind CSS:** https://tailwindcss.com/docs
- **React Native:** https://reactnative.dev/docs
- **Expo:** https://docs.expo.dev

---

**Last Updated:** 2025-11-26
**Version:** 1.0.0
